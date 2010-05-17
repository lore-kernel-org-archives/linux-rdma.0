From: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: compiling against lustre 1.8.2 kernel
Date: Mon, 17 May 2010 13:32:30 -0400
Message-ID: <AANLkTikwu0pcBUNaxJQvTJdBDi18KpcQiUeyM3d_YhSi@mail.gmail.com>
References: <AANLkTil_7L_cbglOcaHKPRmrrntXew9jwxvSrTkxNcnF@mail.gmail.com>
	 <1274113630.396.41.camel@pc.interlinx.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1274113630.396.41.camel-lA68w17JHpfIgqYUaR6mlLDks+cytr/Z@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Brian J. Murrell" <Brian.Murrell-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

it wouldn't appear so, guess i should have checked that. sorry...  i'm
little baffled how they can claim it supports ofed 1.4.2 on a
2.6.18-146.11.1 kernel if ofed doesn't support a 2.6.18-164.11.1...
but i digress, that questions for another list...



On Mon, May 17, 2010 at 12:27 PM, Brian J. Murrell
<Brian.Murrell-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, 2010-05-17 at 12:15 -0400, Michael Di Domenico wrote:
>> I ran across an error when trying to compile OFED-1.4.2 agianst the
>> Lustre 1.8.2 kernel on Redhat v5.4 (2.6.18-164.11.1)
>>
>> /var/tmp/ofed.topdir/BUILD/ofa_kernel_1.4.2/kernel_addons/backport/2=
=2E6.18-EL5.3/include/linux/sched.h:13
>> error: static declaration of '__fatal_signal_pending' follows
>> non-static declaration include/linux/sched.h: 1570 error: previous
>> declaration of '__fatal_signal_pending' was here
>>
>> Any suggestions?
>
> Have you checked that OFED 1.4.2 supports the RHEL5 2.6.18-164.11.1
> kernel? =A0I don't have release notes handy so I don't know.
>
> b.
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
