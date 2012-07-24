From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: The kernel module rdma_ucm.ko can't be loaded in debug kernel
 of RHEL 6.2
Date: Tue, 24 Jul 2012 09:51:13 -0500
Message-ID: <500EB661.5020109@opengridcomputing.com>
References: <CALvMawruRg01YZ1T8xZDiWXV03ZFN7HmAEf7XYn1T6pp=HLG3w@mail.gmail.com> <500EA825.6090909@opengridcomputing.com> <CALvMawqdz=M1qx0NSmWfx+YRe0vzHdYrnbeLg=r21mHdRWj9bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALvMawqdz=M1qx0NSmWfx+YRe0vzHdYrnbeLg=r21mHdRWj9bw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/24/2012 9:18 AM, Dotan Barak wrote:
>
>
> On Tue, Jul 24, 2012 at 4:50 PM, Steve Wise 
> <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org <mailto:swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>> wrote:
>
>     On 7/24/2012 3:27 AM, Dotan Barak wrote:
>>     Hi Steve.
>>
>>     I'm trying to load the RDMA stack, based on the upstream kernel
>>     on debug kernel of RHEL 6.2 (2.6.32-220.el6.x86_64.debug).
>>     The kernel module rdma_ucm.ko can't be loaded in this kernel and
>>     i get the following error messages in 'dmesg':
>>
>
>     No I haven't seen this issue.  Is this a backport problem with the
>     rhel debug kernel, or does this also happen on the upstream kernel
>     as well?
>
>
> I don't think that the problem is with the backport of the code to 
> RHEL6.2,
>  But I didn't test the upstream kernel when the debug features enabled.
>

I don't even see sysctl_check_dir() upstream...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
