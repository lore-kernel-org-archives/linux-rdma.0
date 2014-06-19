From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 78351] New: Missing NULL check of the return value of
 nla_reserve() in function cgroupstats_user_cmd()
Date: Thu, 19 Jun 2014 11:33:57 +0000
Message-ID: <bug-78351-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=78351

            Bug ID: 78351
           Summary: Missing NULL check of the return value of
                    nla_reserve() in function cgroupstats_user_cmd()
           Product: Drivers
           Version: 2.5
    Kernel Version: 2.6.39
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Infiniband/RDMA
          Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
          Reporter: rucsoftsec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
        Regression: No

In function cgroupstats_user_cmd() at kernel/taskstats.c:412, the call to
nla_reserve() at line 338 may return a NULL pointer, but its return value is
never checked against NULL before the call to function nla_data()(called at
line 441), and thus an invalid access error may be triggered.
The related code snippets in function cgroupstats_user_cmd() are as followings.
cgroupstats_user_cmd @ kernel/taskstats.c:412
412 static int cgroupstats_user_cmd(struct sk_buff *skb, struct genl_info
*info)
413 {
414         int rc = 0;
    ...
436         if (rc < 0)
437                 goto err;
438 
439         na = nla_reserve(rep_skb, CGROUPSTATS_TYPE_CGROUP_STATS,
440                                 sizeof(struct cgroupstats));
441         stats = nla_data(na);
442         memset(stats, 0, sizeof(*stats));
443  ...
454         return rc;
455 }

Generally, the return value of nla_reserve() shall be checked against NULL ,
like the following code snippets in function generate_netlink_event().
generate_netlink_event @ drivers/thermal/thermal_sys.c:1227
1227 int generate_netlink_event(u32 orig, enum events event)
1228 {
1229         struct sk_buff *skb;
1230         struct nlattr *attr;
1231         struct thermal_genl_event *thermal_event;
     ...
1254         attr = nla_reserve(skb, THERMAL_GENL_ATTR_EVENT, \
1255                         sizeof(struct thermal_genl_event));
1256 
1257         if (!attr) {
1258                 nlmsg_free(skb);
1259                 return -EINVAL;
1260         }
1261 
1262         thermal_event = nla_data(attr);
1263         if (!thermal_event) {
1264                 nlmsg_free(skb);
1265                 return -EINVAL;
1266         }
     ...
1285 }

the above suspect bug exists Function reset_per_cpu_data() too.
Thak you!

RUC_Soft_Sec, supported by China.X.Orion

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
