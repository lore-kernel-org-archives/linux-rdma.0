From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH libmlx4 0/8] add raw packet QP, resource limitations, fixes/cleanups
Date: Mon, 18 Mar 2013 22:35:15 +0200
Message-ID: <CAJZOPZKGrXm2iThmW6VSmu3qi1Ffn==bJmiAfCfoqOX_AeJjeA@mail.gmail.com>
References: <1348173067-12116-1-git-send-email-ogerlitz@mellanox.com>
	<CAJZOPZJbvpY_8_5ZXpd4SuFxnpZrJ+_LMSUwN4hEfaFA6ErvhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJbvpY_8_5ZXpd4SuFxnpZrJ+_LMSUwN4hEfaFA6ErvhQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 31, 2012 at 9:56 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Sep 20, 2012 at 10:30 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> This batch of libmlx4 patch contains the patch to support raw
>> packet QP, two patches from Sagi that relate to resource
>> limitations, and few simple fixes/cleanups from Dotan.
>> The first three were submitted pretty long while ago, for this
>> re-submission I made some changes in the change-logs and cleaned
>> some checkpatch comments.

> Hi Roland,
> These patches and the libibverbs set I submitted are all marked as
> "new" in your patchwork, planning to get there anytime soon? there are
> more and more patches knocking on the door (the verbs extensions and
> the XRC ones, 64B CQE, more), we kind of must let some get in or at
> least start review, to get room for more ones...

ping, its been six months minus two days and counting for the two raw
ethernet qp simple user space patches (one for libibverbs and one for
libmlx4) to be in the air without any feedback (== marked as new in
patchwork). We have kernel support for this since 3.5 or so, I don't
see if/what is the barrier to pick them up.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
