From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RESEND PATCH V3 for-next 0/3] HW Device hot-removal support
Date: Sun, 17 May 2015 13:33:01 +0300
Message-ID: <55586E5D.1030801@dev.mellanox.co.il>
References: <1431515438-24042-1-git-send-email-yishaih@mellanox.com> <1828884A29C6694DAF28B7E6B8A82373A8FDA36D@ORSMSX109.amr.corp.intel.com> <555486CA.8080409@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373A8FDA931@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FDA931-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/14/2015 7:50 PM, Hefty, Sean wrote:
> Why can't uverbs simply cleanup all resources associated with the open device, similar to what it does when an app closes unexpectedly (just limited to the device in question)?

When an application closes un-expectedly, the application does not 
attempt to make use of open resources, such as FDs and memory mappings.
In the hot-removal case, the application must *continue* to operate 
without crashing.
For example, the application may want to use other RDMA devices.

In this case, all FDs and memory mappings remain open. The semantics of 
these remaining resources may be device-specific.
The proposed framework first of all allows a provider to indicate 
whether hot-removal is supported (i.e., the presence of the 
'disassociate_ucontext' callback), and if so, allow the provider to 
perform the proper cleanup so that the corresponding user-space driver 
will continue to function.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
