From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] Ad IB_MTU_1500|9000 enums.
Date: Mon, 22 Apr 2013 18:00:05 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC440469B5@xmb-rcd-x01.cisco.com>
References: <1364994796-10642-1-git-send-email-jsquyres@cisco.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0156FC7B@CRSMSX102.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A823736F36B9EA@ORSMSX101.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0156FCB1@CRSMSX102.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC43FFA8E0@xmb-rcd-x01.cisco.com>
 <1828884A29C6694DAF28B7E6B8A823736F36CCCA@ORSMSX101.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC43FFDBA8@xmb-rcd-x01.cisco.com>
 <2807E5FD2F6FDA4886F6618EAC48510E01575317@CRSMSX102.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A823736F36D455@ORSMSX101.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E015759CF@CRSMSX102.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4401EEDD@xmb-rcd-x01.cisco.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC44042439@xmb-rcd-x01.cisco.com>
 <51721196.9040606@redhat.com>
 <1828884A29C6694DAF28B7E6B8A823736FD1DD83@ORSMSX109.amr.corp.intel.com>
 <517573C9.6050206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <517573C9.6050206-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <631BE06EC8B3E24BA59D776CAE527C85-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Apr 22, 2013, at 1:30 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> However, for some reason I had it
> in my mind when I was reading the patch that it was against libibverbs.
> That's what I get for staying up late and reviewing when I'm tired :-/


There were other patches against libibverbs that were submitted at the same time.

That being said, I see two obvious ways to go forward, both of which have pros/cons:

1. Extend the enum ib_mtu to include new enum values for 1500 and 9000 -- probably with a different prefix to indicate that they're not IBTA-sanctioned values (note that this will also require corresponding changes in libibverbs, since MTU values get passed up from kernel to userspace).

PRO: fixes the immediate problem
PRO: probably the lowest impact solution; just adding some more enum values
CON: weird naming (IB_ and RDMA_ prefixes in the same ib_mtu enum; probably something similar in userspace)
CON: doesn't do anything to address other MTU values (e.g., what if someone has an MTU of 1498?)

2. Change all instances of ib_mtu/ibv_mtu to an int.  Code such as "switch(mtu) case IBV_MTU_1024: ..." will need to be updated to "switch(mtu) case 1024: ...".

PRO: solves the problem for all MTU values
PRO: eliminates the enum-to-int translation functions
CON: much driver code will need to be updated per above, and also update logic checking for out-of-bounds MTU calues
CON: similarly, userspace apps will need to be updated; it might be worthwhile to bump libibverbs to 2.x, and then intentionally change the MTU field names in ibv_port_attr and ibv_qp_attr so that apps using those fields will fail to compile with libibverbs 2.x (and therefore forcibly realize they need to adapt to the new int MTU values)

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
