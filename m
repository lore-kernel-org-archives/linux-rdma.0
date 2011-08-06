From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: SRP over RoCE
Date: Sat, 06 Aug 2011 17:54:24 -0400
Message-ID: <1312667665.19997.2.camel@obelisk.thedillows.org>
References: <CAO+b5-oeqb79+0V1hG6ZEMR2u-+OxQyxb7zGJhA_J_+WtPADtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-oeqb79+0V1hG6ZEMR2u-+OxQyxb7zGJhA_J_+WtPADtA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David McMillen <davem-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2011-08-06 at 09:31 +0200, Bart Van Assche wrote:
> On Fri, Aug 5, 2011 at 9:17 PM, Bob Pearson
> <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> > There are a couple of issues with SRP/RoCE. One of them is that the current
> > scheme for configuring connections is based on DM MADs. The other is the one
> > you mention. We (SFW) looked at both problems a couple of years ago and came
> > up with a version of SRP that runs over RDMACM.
> 
> Has it been considered to add that ib_srp patch to the ib_rxe patch
> series, such that Dave and Roland can have a look at it ?

David McMillen and I have talked about the patches and cleanup needed in
the past, but it's been a while now.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
