From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: mlx4 missing completions (was Re: [PATCH-v2] ib_srpt: Initial SRP
 Target merge for v3.2-rc1)
Date: Wed, 26 Oct 2011 13:06:57 -0700
Message-ID: <CAL1RGDUmbkCkNYQ_YQYZfNaXvRktG0KU1Pdp6f85UMgocbWrNw@mail.gmail.com>
References: <CAL1RGDV7jhRexKowk9JLcVJhb832RX672Da8UQSPK82OHEsw7A@mail.gmail.com>
 <CAO+b5-oc9KQ5Uw+7RbY1Z6fqbK+x4Bnw8wCrLAaediaqHMPAhA@mail.gmail.com>
 <CAL1RGDX=B4=3wJuBN6st429xarYqdnGAnmZ=r-7zX=8pQ_RjTA@mail.gmail.com> <CAO+b5-qs4PBrERtErfuYVZxhyshsxiFHOgzmFfbyomYZgYk47Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-qs4PBrERtErfuYVZxhyshsxiFHOgzmFfbyomYZgYk47Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 26, 2011 at 11:05 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> Can I conclude from your reply that the "last WQE" event refers to the
> SRQ only and that it does not provide any information about the send
> queue associated with the same QP ?

That is correct as I understand things.  The "last WQE" event was added
to handle the fact that if you have a QP associated to an SRQ, you can't
know how many receives have been taken from the SRQ and are in flight
on the receive queue.  The IB spec is a bit vague on what "last WQE"
actually means but based on the background, I believe it means that the
last request on the receive queue has been processed, without saying
anything about the send queue.

And apparently the Mellanox hardware designers agree with me :)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
