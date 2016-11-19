From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] infiniband: remove WARN that is not kernel bug
Date: Fri, 18 Nov 2016 21:22:42 -0500
Message-ID: <164538.1479522162@turing-police.cc.vt.edu>
References: <1479468277-50798-1-git-send-email-dvyukov@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1479522162_2854P";
         micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1479468277-50798-1-git-send-email-dvyukov@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, leon@kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

--==_Exmh_1479522162_2854P
Content-Type: text/plain; charset=us-ascii

On Fri, 18 Nov 2016 12:24:37 +0100, Dmitry Vyukov said:
> WARNINGs mean kernel bugs.
> The one in ucma_write() points to user programming error
> or a malicious attempt. This is not a kernel bug, remove it.

> -	if (WARN_ON_ONCE(!ib_safe_file_access(filp)))
> +	if (!ib_safe_file_access(filp))
>  		return -EACCES;

In that case, wouldn't this be better?

	if (!ib_safe_file_access(filp)) {
		printk_once("Process %d (%s) tried to do something hinky", pid, comm);
		return _EACCESS;
	}

so the sysadmin becomes aware of the malicious attempt?

--==_Exmh_1479522162_2854P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.5 07/13/2001

iQEVAwUBWC+3co0DS38y7CIcAQK1Ygf9EA//VvRupgZgxC0fx4M1cVn1g6s2oVIH
TlIsaGMN2mwhjiht1E8rMTYbkUjaPuZXDrkzwnSPNneRP6zDLRDhXOr26W2U8pQz
3QaRieGbLOcMtbJghqfv1gavdo7fAWYHCIqe1Vs5yjbyhzjZ53RQF9nhu8GnixZy
dC09WQo0+ls3hbDGf0RnUMpELIMWxdp1ri2P+blrJecp1sircZIboKeY/neKcf9r
d3AnDUkui8e+CeMQv4zYz7epR2YnDqmZPbql6JV6kHVQ61WlrkraUYvyuEpC89L8
s0HXKi4mD6ZuS4F8/QWfa2mP968O6l4D5SorX4qDwr9ox+mRp3rbbQ==
=qX3r
-----END PGP SIGNATURE-----

--==_Exmh_1479522162_2854P--
