From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: Work completion error: "transport retry counter exceeded"
Date: Fri, 27 Jul 2012 10:08:05 -0700
Message-ID: <CAL1RGDUM4b0DMFdA5b_sv1-nz5bU2WEd+YW=txHxHs-JkHRaKQ@mail.gmail.com>
References: <20120725190719.475605dc169353b775cd3463@llnl.gov>
 <CAL1RGDWmpHy43b5TarBWpUk1RXOEdNitXWE4+xRCspgfpwUisQ@mail.gmail.com>
 <CALfB72Ad4+R48Nc-kawsrk1JQo964OkJ6DE46mcR5b9pS2_hEA@mail.gmail.com>
 <CAL1RGDVwy56YL7OLxVuvap5WZRzzZsosQmKBkhWZB73uy3ysDg@mail.gmail.com> <00e901cd6c17$f56161e0$e02425a0$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00e901cd6c17$f56161e0$e02425a0$@com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 27, 2012 at 9:50 AM, Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> Note that both an "RNR-NAK retry count exceeded" and a "timeout" error are
> reported in the same way, as a locally detected error.

Not quite right.  There are two different work completion statuses:

        IBV_WC_RETRY_EXC_ERR
        IBV_WC_RNR_RETRY_EXC_ERR

which libibverbs will format as

        "transport retry counter exceeded"
        "RNR retry counter exceeded"

so it is pretty easy to tell the difference between the two errors.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
