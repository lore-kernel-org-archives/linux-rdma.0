From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RESEND PATCH V3 for-next 0/3] HW Device hot-removal support
Date: Mon, 25 May 2015 17:01:50 +0300
Message-ID: <55632B4E.1070400@dev.mellanox.co.il>
References: <1431515438-24042-1-git-send-email-yishaih@mellanox.com> <1828884A29C6694DAF28B7E6B8A82373A8FDA36D@ORSMSX109.amr.corp.intel.com> <555486CA.8080409@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373A8FDA931@ORSMSX109.amr.corp.intel.com> <55586E5D.1030801@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373A8FDC9A4@ORSMSX109.amr.corp.intel.com> <HE1PR05MB1418D0CE0E031DA35E3DDEBAB1C30@HE1PR05MB1418.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR05MB1418D0CE0E031DA35E3DDEBAB1C30-eBadYZ65MZ87O8BmmlM1zNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/19/2015 7:17 PM, Liran Liss wrote:
>> From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
>
>>> these remaining resources may be device-specific.
>>> The proposed framework first of all allows a provider to indicate
>>> whether hot-removal is supported (i.e., the presence of the
>>> 'disassociate_ucontext' callback), and if so, allow the provider to
>>> perform the proper cleanup so that the corresponding user-space driver
>>> will continue to function.
>>
>> The approach seems strange.  The driver knows that it is being removed.  It
>> was informed up front which open contexts were associated with user space
>> processes.  But the driver calls up to indicate that it is being removed, so that
>> the upper layer can call back down to tell the driver to process the removal.
>>
>> I wasn't asking what this series did.  I was asking why the uverbs driver just
>> can't delete the underlying resources.  That's the natural thing to expect.
>
> I suppose that the main issue would be handling existing user memory mappings,
> which cannot be just invalidated -- the user-space driver may not be aware of the
> device removal and may access this memory concurrently, and we don't want it
> to crash.
>
> The meaning of these mappings is device specific: some devices only write them,
> while others read them, expecting some specific format. That's why we need
> device-specific code for this.
>
> While it is true that the device initiates the removal process, the current flow is
> to let every ib_client first detach itself before device-specific cleanups. In this regard,
> ib_uverbs is just another client.
> In addition, the "per-open" (fd) state is held in ib_ucontext, which is maintained by
> ib_uverbs. The device driver doesn't hold a duplicate list of open HCA handles, so
> it relies on ib_uverbs to iterate the relevant contexts and trigger the device-specific
> stuff.
>

Hi Doug,
Please see Liran's answer above, it clarified the need for that 
approach. Can you please take into "for-next" ?

Yishai







--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
