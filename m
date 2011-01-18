From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] RDMA/ucma: Copy iWARP route information.
Date: Tue, 18 Jan 2011 17:16:49 -0600
Message-ID: <4D361F61.7080709@opengridcomputing.com>
References: <20100510154656.22415.47740.stgit@build.ogc.int>	<4BF45F1A.4010707@opengridcomputing.com>	<adaeih7eegq.fsf@roland-alpha.cisco.com>	<4BF4618C.1090106@opengridcomputing.com>	<4D2CD02C.1000607@opengridcomputing.com> <ada1v4i55wv.fsf@cisco.com> <4D360C7B.30207@opengridcomputing.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25C1C997FD@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25C1C997FD-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/18/2011 05:14 PM, Hefty, Sean wrote:
>> Did this:
>>
>> http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg03182.html
>>
>> ever make it upstream?
> No, but this patch set is still listed in patchworks as new.  I just updated the set to 2.6.37 and pushed those changes into an af_ib branch in my git tree.
>
> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

The reason I asked is that my small change for adding the mac addresses in iwarp routes will cause a merge issue.   
Roland, do you have plans to merge sean's series soon?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
