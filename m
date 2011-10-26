From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH-v2] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Tue, 25 Oct 2011 23:41:38 -0700
Message-ID: <1319611298.8550.58.camel@haakon2.linux-iscsi.org>
References: <1319435841-19046-1-git-send-email-nab@linux-iscsi.org>
	 <CAO+b5-p-qRe_GvuB3+WWqk9d_P_1rkqB0OFvQ0Y0jTHK+oc=Zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-p-qRe_GvuB3+WWqk9d_P_1rkqB0OFvQ0Y0jTHK+oc=Zg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2011-10-26 at 08:09 +0200, Bart Van Assche wrote:
> On Mon, Oct 24, 2011 at 7:57 AM, Nicholas A. Bellinger
> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> > +static int srpt_write_pending(struct se_cmd *se_cmd)
> > +{
> > +       struct srpt_rdma_ch *ch;
> > +       struct srpt_send_ioctx *ioctx;
> > +       enum srpt_command_state new_state;
> > +       enum rdma_ch_state ch_state;
> > +       int ret;
> > +
> > +       ioctx = container_of(se_cmd, struct srpt_send_ioctx, cmd);
> > +
> > +       new_state = srpt_set_cmd_state(ioctx, SRPT_STATE_NEED_DATA);
> > +       WARN_ON(new_state == SRPT_STATE_DONE);
> > +
> > +       ch = ioctx->ch;
> > +       BUG_ON(!ch);
> > +
> > +       ch_state = srpt_get_ch_state(ch);
> > +       switch (ch_state) {
> > +       case CH_CONNECTING:
> > +               /* This code should never be reached. */
> > +               __WARN();
> > +               ret = -EINVAL;
> > +               goto out;
> > +       case CH_LIVE:
> > +               break;
> > +       case CH_DISCONNECTING:
> > +       case CH_DRAINING:
> > +       case CH_RELEASING:
> > +               pr_debug("cmd with tag %lld: channel disconnecting\n",
> > +                        ioctx->tag);
> > +               srpt_set_cmd_state(ioctx, SRPT_STATE_DATA_IN);
> > +               ret = -EINVAL;
> > +               goto out;
> > +       }
> > +       ret = srpt_xfer_data(ch, ioctx);
> > +
> > +out:
> > +       return ret;
> > +}
> 
> If not enough memory is available to perform a SCSI write, this
> function returns -ENOMEM and the LIO core will report that error to
> the initiator. At least when mounting a filesystem on top of ib_srp
> and when performing asynchronous I/O that will result in data loss.
> Shouldn't the LIO core retry writes as long as not enough memory is
> available ?
> 
> A similar argument holds for reads.

So target_core_fabric_ops->write_pending(), ->queue_data_in() and
->queue_status() currently check for a -EAGAIN return in order to signal
that QUEUE_FULL logic should kick in for the associated se_cmd
descriptor.

I think it's reasonable to also allow fabric modules to signal
QUEUE_FULL using -ENOMEM as well, so I'll go ahead and change this for
v3.2 w/ ib_srpt and will send out a patch shortly.

Also, I did notice one extra case in srpt_map_sg_to_ib_sge() ->
srpt_xfer_data() that returns -EBUSY, so i'll change this  to -EAGAIN to
signal QUEUE_FULL as well.

Thanks for the feedback Bart!

--nab





--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
