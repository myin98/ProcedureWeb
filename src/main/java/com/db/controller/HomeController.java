package com.db.controller;

import lombok.RequiredArgsConstructor;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class HomeController {

    @Autowired @Qualifier("sql1")
    private SqlSession sql1;

    @GetMapping("/")
    public String home() {
        return "home";
    }

    @GetMapping("/list")
    public String list(Model model) {
        List<Map<String, Object>> list = sql1.selectList("sql.list");
        model.addAttribute("list", list);
        return "list";
    }

    @GetMapping("/add")
    public String add() {
        return "add";
    }

    @PostMapping("/insert")
    public String add(@RequestParam("nm") String nm, @RequestParam("gender") boolean gender) {
        sql1.insert("sql.insert", new HashMap<String, Object>() {{
            put("nm", nm);
            put("gender", gender);
        }});
        return "redirect:/list";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam("no") Integer no, Model model) {
        model.addAttribute("data", sql1.selectOne("sql.selectOne", no));
        return "detail";
    }

    @GetMapping("/edit")
    public String edit(@RequestParam("no") Integer no, Model model) {

        model.addAttribute("data", sql1.selectOne("sql.selectOne", no));
        return "edit";
    }
    @PostMapping("/update")
    public String update(@RequestParam("no") Integer no,
                         @RequestParam("nm") String nm,
                         @RequestParam("gender") boolean gender,
                         Model model)
    {
        sql1.update("sql.edit", new HashMap<String, Object>() {{
            put("no", no);
            put("nm", nm);
            put("gender", gender);
        }});
        return "redirect:/detail?no=" + no;
    }

    @GetMapping("/del")
    public String del(@RequestParam("no") Integer no) {
        sql1.delete("sql.del", no);
        return "redirect:/list";
    }
    
    @GetMapping("/cntgender")
    public String cntGender(Model model) {
    	model.addAttribute("list", sql1.selectList("sql.cntGenderList"));
    	return "countGender";
    }

}
