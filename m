From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] libibverbs: add path record definitions to sa.h
Date: Wed, 19 May 2010 14:31:00 -0700
Message-ID: <19BC9BFFCFA94F9E8A8DFE52A54846D2@amr.corp.intel.com>
References: <2420730B531C4665BD842A7F46007DA2@amr.corp.intel.com>	<adapr18zmmj.fsf@roland-alpha.cisco.com>	<63BD07796ED544AEAC6E41E669DC6EAC@amr.corp.intel.com>	<adavdano5lb.fsf@roland-alpha.cisco.com>	<4BF146F2.5060909@opengridcomputing.com> <adask5pnav3.fsf@roland-alpha.cisco.com> <4BF29E3D.40704@opengridcomputing.com> <BE2BFE91933D1B4089447C64486040801D4D8232@irsmsx503.ger.corp.intel.com> <4BF40B09.6070809@opengridcomputing.com> <4BF4565B.4040208@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BF4565B.4040208-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Steve Wise' <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Also, There is a rdmacm kernel change to pass up iwarp L2 addresses once
>a cm_id has resolved the addresses.  I posted it earlier and I think
>Sean is going to integrate it for 2.6.36.

I believe that the patch you posted earlier is sufficient for 2.6.35.  I just
need to update my patch set for AF_IB support, which were written assuming that
iWarp devices did not return L2 addresses.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
