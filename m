From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] IB/usnic: Handle 0 counts in resource allocation
Date: Sat, 12 Dec 2015 09:29:26 +0200
Message-ID: <CALq1K=JjQfXwge8EHMrNR9uqB3-sxRWCWr6PN7pA_S_GTMvHag@mail.gmail.com>
References: <1449686539-29959-6-git-send-email-neescoba@cisco.com>
 <20151210064702.GC8662@leon.nu> <5669D0F0.7010104@cisco.com>
 <20151210194734.GF8662@leon.nu> <5669F2A7.8060502@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5669F2A7.8060502-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Thanks for looking at the code.  I am still not understanding your point.
>> Old code:
>> usnic_vnic_res_free_cnt(vnic, type) == 0 and cnt == 1 will return EINVAL
> Yes:
>         if (0 < 1 || 1 < 1 || !owner)
>                 return -EINVAL;
>> New code
>> snic_vnic_res_free_cnt(vnic, type) == 0 and cnt == 1 will pass and will
>> pass te "if (cnt > 0)" check below and will decrease free_cnt variable
>> to be below zero.
> This I don't understand.  The following still fails with -EINVAL.
>         if (0 < 1 || 1 < 0 || !owner)
>                 return -EINVAL;

Thank you for clarifying it. I don't know why I missed first comparison.
Sorry for bothering you.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
