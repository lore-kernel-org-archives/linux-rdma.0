From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH ib-next 2/3] IB/core: IB/core: Allow legacy verbs through
 extended interfaces
Date: Tue, 10 Nov 2015 12:25:41 +0200
Message-ID: <CAAKD3BAkJiYV8mHUUqAwPZwCsyRR7579+jUC4idGy6snM6rbHA@mail.gmail.com>
References: <1446745208-17733-1-git-send-email-eli@mellanox.com>
	<1446745208-17733-3-git-send-email-eli@mellanox.com>
	<CAAKD3BDq_o+J3yM1qAKg_x35Dps5Ne_ffaD_Mz55a272pwQcJg@mail.gmail.com>
	<564041C4.1090303@mellanox.com>
	<20151109223531.GB1305@obsidianresearch.com>
	<20151109230531.GF20103@x-vnc01.mtx.labs.mlnx>
	<20151109231542.GA20707@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151109231542.GA20707-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 1:15 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Nov 10, 2015 at 01:05:31AM +0200, Eli Cohen wrote:
>> On Mon, Nov 09, 2015 at 03:35:31PM -0700, Jason Gunthorpe wrote:
>> > On Mon, Nov 09, 2015 at 08:48:36AM +0200, Haggai Eran wrote:
>> > > On 08/11/2015 17:04, Matan Barak wrote:
>> > > >> @@ -704,6 +719,10 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
>> > > >> >         }
>> > > >> >
>> > > >> >         command = hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
>> > > >> > +       if (verify_command_mask(ib_dev, command)) {
>> > > >> > +               ret = -EINVAL;
>> > > > Why did you replace ENOSYS with EINVAL?
>> > >
>> > > I think ENOSYS is meant only to represent a system call number that
>> > > isn't supported. There was a change in checkpatch that now warns about
>> > > it [1]. I'm not sure the intention was to fix existing uses though.
>> >
>> > Within verbs we should have two kinds of return - not supported
>> > request, and supported request with invalid parameters.
>> >
>> > Maybe use EOPNOTSUPP ?
>> >
>>
>> What about Matan's concern regarding legacy code? Maybe we should
>> leave ENOSYS as that's how it is all over the IB stack code.
>>
>> quote:
>> I think it could break old applications:
>> err = extended_verb(the_first_extension_we_added);
>> if (err == ENOSYS)
>>       err = legacy_verb();
>> if (err)
>>     return err;
>>
>> Such applications used the first extension (that was added during the
>> addition of the extended verb) and when they realized it's not
>> supported, they dropped to the legacy verb. This change can now cause
>> the return of -EINVAL an early termination with an error.
>
> Since the change is to make the kernel do the above fall back
> internally, this specific example doesn't make alot of sense to worry
> about. Ie the extended verb won't fail anymore, and if it does the
> legacy one won't work anyhow.
>

The kernel will do the above fallback if the command is a legacy
command wrapped in an extended command (i.e - no extra flags).
If an application uses one of the extended values, and fall back to
legacy verb on ENOSYS, it'll behave differently after this change:
Re-posting this example:

err = extended_verb(*the_first_extension_we_added*); /* Kernel won't
fall back to legacy verbs here, as we use an actual extended request
*/
if (err == ENOSYS)
      err = legacy_verb();
if (err)
    return err;

> But if there is something out there that does care about ENOSYS we
> should try to keep it, but don't convert ENOSYS to EINVAL.
>
> Also, when the driver tests the ex flags for support it should be
> returning EOPNOTSUPP or such not EINVAL.. Return codes for the ex
> stuff could stand a good sanity audit.
>
> Jason

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
