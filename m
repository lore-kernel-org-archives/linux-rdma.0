From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network and RDMA
 subsystem
Date: Fri, 22 Dec 2017 11:29:38 +0000
Message-ID: <OF663C0801.8471532E-ON002581FE.003B73D6-002581FE.003F2369@notes.na.collabserv.com>
References: <20171014064132.GT2106@mtr-leonro.local>,<20171008130342.GV25829@mtr-leonro.local>
 <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-4-bmt@zurich.ibm.com>
 <OF406E95F8.33CF80BB-ON002581B9.00073D6F-002581B9.00081F69@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171014064132.GT2106-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


-----Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote: -----

>To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>Date: 10/14/2017 08:41AM
>Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network
>and RDMA subsystem
>
>On Sat, Oct 14, 2017 at 01:28:43AM +0000, Bernard Metzler wrote:
>> -----Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote: -----
>>
>> >> +
>> >> +#define SIW_MAX_IF 12
>> >> +static int if_cnt;
>> >> +static char *iface_list[SIW_MAX_IF] = {[0 ... (SIW_MAX_IF-1)] =
>> >'\0'};
>> >> +module_param_array(iface_list, charp, &if_cnt, 0444);
>> >> +MODULE_PARM_DESC(iface_list, "Interface list siw attaches to if
>> >present");
>> >> +
>> >> +static bool loopback_enabled = 1;
>> >> +module_param(loopback_enabled, bool, 0644);
>> >> +MODULE_PARM_DESC(loopback_enabled, "enable_loopback");
>> >> +
>> >> +LIST_HEAD(siw_devlist);
>> >> +
>> >> +static int cpu_cnt;
>> >> +static char *tx_cpu_list[MAX_CPU] = {[0 ... (MAX_CPU-1)] =
>'\0'};
>> >> +module_param_array(tx_cpu_list, charp, &cpu_cnt, 0444);
>> >> +MODULE_PARM_DESC(tx_cpu_list, "List of CPUs siw TX thread shall
>be
>> >bound to");
>> >
>> >No module parameters please.
>> OK. Would you have a pointer which sheds some light on that
>> rule? Thank you!
>>
>
>It is not rule, but common knowledge exactly as BUG_ON which is not
>prohibited, but makes no sense in low level driver code.
>
>The module parameters sometimes make sense, for example in subsystem
>level where they can apply to whole devices underneath.
>
>But most of the time, they indicate complete ignorance of users in
>favor
>of easy developer's life.
>
>For people, like me, who doesn't run modules at all, the change in
>module parameters require rebuild of initramfs and in more extreme
>cases rebuild of SELinux labels.
>

I will try to finish up a new patch set for siw over
Christmas holidays.

One question I have - what is the recommended way of replacing
those module parameters, if we need to flexibly parameterize
things from user land? For the rxe driver, I see the usage of
module_param_cb, but this probably is not what we want in the
long run? Would a sysctl be appropriate, or a char device
(we may need to pass strings like interface names), or configfs?

Thanks very much!
Bernard.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
