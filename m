From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core v4 0/4] ibacm: acmp retry issues
Date: Mon, 20 Nov 2017 10:28:40 +0200
Message-ID: <20171120082840.GC18825@mtr-leonro.local>
References: <20171115193155.470.85049.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lQbPBi7/wdme3SBe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171115193155.470.85049.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--lQbPBi7/wdme3SBe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 15, 2017 at 02:34:25PM -0500, Michael J. Ruhl wrote:
> While testing the retry mechanism for the acmp provider, I observed
> that the retry event_wait() did not appear to be working correctly.
> After studying the issue a bit more, I discovered that there were a
> couple of issues.
>
> This patch set addresses those issues.
>
> v2 - added patch for MONOTONIC time base
> v3 - Updated and cleaned various type cast issues
> v4 - Remove unnecessary typecasting
>
> ---
>
> Michael J. Ruhl (4):
>       ibacm: Fix an incorrect expiration check for the retry timer
>       ibacm: Calculate correct tv_nsec value in event_wait()
>       ibacm: Fix a retry loop calculation race condition
>       ibacm: Use MONOTONIC time base to avoid timer expiration issues

Thanks, applied.

--lQbPBi7/wdme3SBe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloSkjgACgkQ5GN7iDZy
WKeezBAAkOAatiPIJ4wqu8b6khpRx71qRkb/Zl1dyJGLBtyI0ajgctaTbxnKL1lL
k+Xu/ke98SM/4MLhSauImbNMj5kgYzd85+KYQj5ZJYQU9bY27f4zct28G9DLkHLS
8wsMfjZQJ2s3m/I+78VbDviH3QbHrMAT6ZvtJoNaEiDdgnwpRfqeCMKCW2tHVmsF
Wcf//JEfgaFIzYtLCwMUVwF0Q0zzG/fAIQc4wmicPc9UEBffqsYzgrydTos1bYRM
TbuDrg9ppsO7Ry9P8/sGA5f+gn7AOp8z3L86ALm1AsYfkdqWHW5RCFvCPAweNLrb
92gUWtPRBgZ6L+PbRmL6zHlG+xoNgnNnYj+ODajfYwyTE0/3gXhCOxUN8sZXy9Hw
6n7q/zY6iEiepMRYletH9/LVB4fdvCm8+yE1Us4ct0OpyoVGIKHfuCE9wB02IUZ/
UJXqkhwxAddHP3xaXy+1wCrYY0VnyG5kkDq0rkikQrCQlzzmso3u3lbUjL+fLISt
nZ3r59hrdcghx0Cc7WdB/m/QncJyyru5ZYGbH25wMncu69geInr3yEJDUQmkO2MT
0U8k1LSzQcDKzIGTs9w1RB9U6ctFZfYE7xuky20qJsIR8TSwsSHDl1PwdJmFSbK1
lZPAYH2OzW2+NexaLg4raXgPXG+7kQ7Ga1pH58tWYVUA9WzI2E4=
=7Ouw
-----END PGP SIGNATURE-----

--lQbPBi7/wdme3SBe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
