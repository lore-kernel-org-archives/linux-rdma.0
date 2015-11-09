From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH ib-next 2/3] IB/core: IB/core: Allow legacy verbs through
 extended interfaces
Date: Mon, 9 Nov 2015 18:11:49 +0200
Message-ID: <CAAKD3BAJi0XSU1VW10jogaHL7wYT6fcDSw=q1Zpu+4+Mf760nQ@mail.gmail.com>
References: <1446745208-17733-1-git-send-email-eli@mellanox.com>
	<1446745208-17733-3-git-send-email-eli@mellanox.com>
	<CAAKD3BDq_o+J3yM1qAKg_x35Dps5Ne_ffaD_Mz55a272pwQcJg@mail.gmail.com>
	<20151109155539.GA116821@x-vnc01.mtx.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151109155539.GA116821-lgQlq6cFzJSjLWYaRI30zHI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 9, 2015 at 5:55 PM, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Sun, Nov 08, 2015 at 05:04:55PM +0200, Matan Barak wrote:
>> > +static int verify_command_mask(struct ib_device *ib_dev, __u32 command)
>> > +{
>> > +       u64 mask;
>> > +
>> > +       if (command <= IB_USER_VERBS_CMD_OPEN_QP)
>>
>> I think using IB_USER_VERBS_CMD_THRESHOLD is clearer, but I don't
>> think we need two uverbs_cmd_mask vendor variables.
>> IMHO, a vendor shouldn't care if it's an extended/legacy uverb
>> command. Maybe we should replace uverbs_cmd_mask with a bitmap.
>>
>> > +               mask = ib_dev->uverbs_cmd_mask;
>> > +       else
>> > +               mask = ib_dev->uverbs_ex_cmd_mask;
>> > +
>> > +       if (mask & ((u64)1 << command))
>> > +               return 0;
>> > +
>> > +       return -1;
>> > +}
>> > +
>
> But IB_USER_VERBS_CMD_OPEN_QP is the last legacy verbs and I prefer a
> more restrictive approach to avoid potentail issues in the future.
>

So maybe it's worth adding a IB_USER_VERBS_CMD_LAST_LEGACY_VERB.
It looks a bit weird why you explicitly check for IB_USER_VERBS_CMD_OPEN_QP.

>> >  static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
>> >                              size_t count, loff_t *pos)
>> >  {
>> > @@ -704,6 +719,10 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
>> >         }
>> >
>> >         command = hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
>> > +       if (verify_command_mask(ib_dev, command)) {
>> > +               ret = -EINVAL;
>>
>> Why did you replace ENOSYS with EINVAL?
>>
>
> Like Haggai mentioned in the other response, checkpatch issues error
> on this claiming that ENOSYS is reserved to unavailable system calls.
> Is it applicable only for new implementations I am not sure. I don't
> have clear preference for either ENOSYS or EINAVL.

I think it could break old applications:
err = extended_verb(the_first_extension_we_added);
if (err == ENOSYS)
      err = legacy_verb();
if (err)
    return err;

Such applications used the first extension (that was added during the
addition of the extended verb) and when they realized it's not
supported, they dropped to the legacy verb. This change can now cause
the return of -EINVAL an early termination with an error.

>> > +               goto out;
>> > +       }
>> >
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
