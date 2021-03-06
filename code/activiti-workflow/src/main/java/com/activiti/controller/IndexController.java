package com.activiti.controller;

import com.activiti.common.utils.CommonUtil;
import com.activiti.common.utils.ConstantsUtils;
import com.activiti.mapper.ScheduleMapper;
import com.activiti.pojo.schedule.ScheduleDto;
import com.activiti.pojo.user.StudentWorkInfo;
import com.activiti.service.ScheduleService;
import com.activiti.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by 12490 on 2017/8/1.
 */
@Controller
public class IndexController {
    private final Logger logger = LoggerFactory.getLogger(IndexController.class);

    @Autowired
    private CommonUtil commonUtil;
    @Autowired
    private UserService userService;
    @Autowired
    private ScheduleService scheduleService;
    @Autowired
    private ScheduleMapper scheduleMapper;

    /**
     * 登录页面
     *
     * @param request
     * @param model
     * @return
     */
    @RequestMapping("/login")
    public String greeting(HttpServletRequest request, ModelMap model) {
        String email = request.getParameter("email");
        String redirectUrl = request.getParameter("redirectUrl");
        if ("".equals(email) || null == email) {
            model.put("redirectUrl", redirectUrl);
            return "login";
        } else if (!commonUtil.emailFormat(email)) {
            logger.info("邮箱地址错误：" + email);
            model.put("redirectUrl", redirectUrl);
            model.put("emailValidate", "false");
            return "login";
        } else {
            request.getSession().setAttribute(ConstantsUtils.sessionEmail, email);
            if ("".equals(redirectUrl) || null == redirectUrl)
                return "redirect:/index";
            else
                return "redirect:" + redirectUrl;
        }
    }

    /**
     * 首页
     *
     * @return
     */
    @RequestMapping("/index")
    public String index() {
        return "index";
    }

    /**
     * 退出登录
     *
     * @param request
     * @return
     */
    @RequestMapping("/logout")
    public String logout(HttpServletRequest request) {
        request.getSession().removeAttribute(ConstantsUtils.sessionEmail);
        return "redirect:/login";
    }

    /**
     * 配置时间表页面
     *
     * @param request
     * @return
     */
    @RequestMapping("/timeConf")
    public String timeConf(HttpServletRequest request) {
        return "submodule/timeConf";
    }

    /**
     * 已完成的任务
     *
     * @param request
     * @return
     */
    @RequestMapping("/jobDone")
    public String jobDone(HttpServletRequest request) {
        return "submodule/jobDone";
    }

    /**
     * 成绩查看
     *
     * @param request
     * @return
     */
    @RequestMapping("/gradeInfo")
    public String gradeInfo(HttpServletRequest request, ModelMap modelMap) {
        if (commonUtil.isManageRole(CommonUtil.getEmailFromSession(request))) {
            List<ScheduleDto> scheduleDtoList = scheduleMapper.selectAllOfScheduleTime();
            modelMap.put("scheduleDtoList", scheduleDtoList);
            return "submodule/gradeInfoAdminView";
        } else {
            return "submodule/gradeInfo";
        }
    }

    /**
     * 答题页面
     *
     * @param request
     * @return
     */
    @RequestMapping("/answer")
    public String answer(HttpServletRequest request, ModelMap modelMap) {
        List<ScheduleDto> scheduleDtoList = scheduleMapper.selectAllOfScheduleTime();
        modelMap.put("scheduleDtoList", scheduleDtoList);
        return "submodule/answer";
    }

    /**
     * 互评页面
     *
     * @param request
     * @return
     */
    @RequestMapping("/assessment")
    public String assessment(HttpServletRequest request, ModelMap modelMap) {
        String email = CommonUtil.getEmailFromSession(request);
        List<ScheduleDto> scheduleDtoList = new ArrayList<>();
        scheduleMapper.selectAllOfScheduleTime().forEach(scheduleDto -> {
            String courseCode = scheduleDto.getCourseCode();
            StudentWorkInfo studentWorkInfo = userService.selectStudentWorkInfo(new StudentWorkInfo(courseCode, email));
            if (null != studentWorkInfo && null == studentWorkInfo.getJoinJudgeTime())
                scheduleDtoList.add(scheduleDto);
        });
        modelMap.put("scheduleDtoList", scheduleDtoList);
        return "submodule/assessment";
    }

    /**
     * 成绩审核页面
     *
     * @param request
     * @return
     */
    @RequestMapping("/judgement")
    public String judgement(HttpServletRequest request) {
        return "submodule/judgement";
    }

    /**
     * 邮件发送情况页面
     *
     * @param request
     * @return
     */
    @RequestMapping("/emailLogView")
    public String emailLogView(HttpServletRequest request) {
        return "submodule/emailLog";
    }

    /**
     * 管理员配置页面
     *
     * @param request
     * @return
     */
    @RequestMapping("/userRole")
    public String userRole(HttpServletRequest request, ModelMap modelMap) {
        modelMap.put("userRoleList", userService.selectAllUserRole());
        return "submodule/userRole";
    }

    /**
     * 管理员配置页面
     *
     * @param request
     * @return
     */
    @RequestMapping("/logView")
    public String logView(HttpServletRequest request, ModelMap modelMap) {
        return "submodule/logView";
    }

    /**
     * 测试页面
     *
     * @param modelMap
     * @return
     */
    @RequestMapping("/test")
    public String test(ModelMap modelMap, HttpServletRequest request) throws Exception {
        if (!commonUtil.isManageRole(CommonUtil.getEmailFromSession(request))) throw new Exception("只有管理员可以查看");
        modelMap.put("courseCode", "S12345");
        modelMap.put("workDetail", "hfsjdfgsdufsujcnjds");
        modelMap.put("email", "email");
        return "mail/test";
    }
}
