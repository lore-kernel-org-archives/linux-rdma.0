From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: SRP over RoCE
Date: Sat, 6 Aug 2011 09:31:28 +0200
Message-ID: <CAO+b5-oeqb79+0V1hG6ZEMR2u-+OxQyxb7zGJhA_J_+WtPADtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David McMillen <davem-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 5, 2011 at 9:17 PM, Bob Pearson
<rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> There are a couple of issues with SRP/RoCE. One of them is that the current
> scheme for configuring connections is based on DM MADs. The other is the one
> you mention. We (SFW) looked at both problems a couple of years ago and came
> up with a version of SRP that runs over RDMACM. SRP was standardized before
> RDMACM was a gleam in Sean's eye and assumes that it has the entire private
> data area for CM MADs to pass parameters. But if you squeeze a little you
> can get it all in after the area that RDMACM takes. We have versions of SRPI
> and SRPT that can use RDMACM for connection setup. Since RDMACM supports
> connection setup automatically for RoCE you're all fixed. In order to make
> this commercially practical you would have to go back to NCITS and update
> the SRP standard but I'm not too sure that there is enough interest to make
> that happen. The other problem requires making changes to the special file
> that sets up the connection. We also have this patch.

Has it been considered to add that ib_srp patch to the ib_rxe patch
series, such that Dave and Roland can have a look at it ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
