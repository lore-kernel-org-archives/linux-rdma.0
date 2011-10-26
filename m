From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH-v2] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Wed, 26 Oct 2011 08:09:38 +0200
Message-ID: <CAO+b5-p-qRe_GvuB3+WWqk9d_P_1rkqB0OFvQ0Y0jTHK+oc=Zg@mail.gmail.com>
References: <1319435841-19046-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319435841-19046-1-git-send-email-nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 24, 2011 at 7:57 AM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> +static int srpt_write_pending(struct se_cmd *se_cmd)
> +{
> + =A0 =A0 =A0 struct srpt_rdma_ch *ch;
> + =A0 =A0 =A0 struct srpt_send_ioctx *ioctx;
> + =A0 =A0 =A0 enum srpt_command_state new_state;
> + =A0 =A0 =A0 enum rdma_ch_state ch_state;
> + =A0 =A0 =A0 int ret;
> +
> + =A0 =A0 =A0 ioctx =3D container_of(se_cmd, struct srpt_send_ioctx, =
cmd);
> +
> + =A0 =A0 =A0 new_state =3D srpt_set_cmd_state(ioctx, SRPT_STATE_NEED=
_DATA);
> + =A0 =A0 =A0 WARN_ON(new_state =3D=3D SRPT_STATE_DONE);
> +
> + =A0 =A0 =A0 ch =3D ioctx->ch;
> + =A0 =A0 =A0 BUG_ON(!ch);
> +
> + =A0 =A0 =A0 ch_state =3D srpt_get_ch_state(ch);
> + =A0 =A0 =A0 switch (ch_state) {
> + =A0 =A0 =A0 case CH_CONNECTING:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* This code should never be reached. *=
/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 __WARN();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 case CH_LIVE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case CH_DISCONNECTING:
> + =A0 =A0 =A0 case CH_DRAINING:
> + =A0 =A0 =A0 case CH_RELEASING:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_debug("cmd with tag %lld: channel di=
sconnecting\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ioctx->tag);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 srpt_set_cmd_state(ioctx, SRPT_STATE_DA=
TA_IN);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 ret =3D srpt_xfer_data(ch, ioctx);
> +
> +out:
> + =A0 =A0 =A0 return ret;
> +}

If not enough memory is available to perform a SCSI write, this
function returns -ENOMEM and the LIO core will report that error to
the initiator. At least when mounting a filesystem on top of ib_srp
and when performing asynchronous I/O that will result in data loss.
Shouldn't the LIO core retry writes as long as not enough memory is
available ?

A similar argument holds for reads.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
