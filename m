From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: stuck iscsi/iser target with linux-4.15.0-rc1
Date: Mon, 18 Dec 2017 11:12:11 -0600
Message-ID: <030e01d37823$57f99800$07ecc800$@opengridcomputing.com>
References: <000801d36ac6$9e9f5f70$dbde1e50$@opengridcomputing.com> <0ba7e891-f020-26fb-9945-9e824332593c@grimberg.me> <018901d36d17$6a703410$3f509c30$@opengridcomputing.com> <1dee9f68-a81b-b7b8-9e70-e0ef5c63c520@grimberg.me> <01bd01d3745a$f4bc82f0$de3588d0$@opengridcomputing.com> <01c701d37462$87371f30$95a55d90$@opengridcomputing.com> <01c901d37462$be431240$3ac936c0$@opengridcomputing.com> <cbe1b731-8e37-884a-1406-6a7ca1f6a0be@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cbe1b731-8e37-884a-1406-6a7ca1f6a0be-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Max Gurtovoy' <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'target-devel' <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> hi Steve,
> 
> On 12/14/2017 12:35 AM, Steve Wise wrote:
> >>
> >> I tried with 4.14.0 and got the same results.  I then backed up to 4.9.44 and I
> can
> >> discovery/login again.  I'll see if I can bisect this out, unless somebody knows
> >> about current problems with iser?
> >
> > Actually, 4.9.44 has the same issue.  It works with iscsi/tcp, not iser. I must be
> doing something wrong in my setup.
> 
> can you run "targetcli ls" on your target side ?
> also "iscsiadm -V" on the initiator side ?
> can you try running with ib link layer ?
> 
> I'll try to find similar setup to repro in our labs.

Hi Max, I'm setting this up on other systems at the moment.  If I can reproduce any of this, I'll reply with more details.

Thanks!

Steve.



---
This email has been checked for viruses by AVG.
http://www.avg.com

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
