From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] rdma: Add Jason as a co-maintainer
Date: Sat, 18 Nov 2017 09:26:25 +0200
Message-ID: <20171118072625.GQ18825@mtr-leonro.local>
References: <20171116204400.GA28216@mellanox.com>
 <1510941272.2846.46.camel@wdc.com>
 <20171117181410.GL4276@ziepe.ca>
 <1510947901.3973.26.camel@redhat.com>
 <20171117213227.GQ4276@ziepe.ca>
 <1510969467.3973.83.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oXuB1DDkBcw8yjUl"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1510969467.3973.83.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--oXuB1DDkBcw8yjUl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 17, 2017 at 08:44:27PM -0500, Doug Ledford wrote:
>
> If you split step 5 above into 5a) Push from local work repo to local
> prep repo and 5b) Do full kernel build in prep repo to test that all
> code needed to compile is tracked by git, it would catch that mistake
> before it makes it outside the firewall.  That's a change I may make
> just to be on the safe side in the future.

I'm using git worktree command [1] for that.

If it helps, this is snippet from my scripts:

-----------------------------------------
REPORT_FILE=$(mktemp)

function do_one {
	SHA1=$1
	REPORT_FILE=$2
	PDIR=$(mktemp -d)

	git worktree add $PDIR $SHA1
	echo "Redirecting the output to $REPORT_FILE"
	pushd $PDIR &>> $REPORT_FILE
	x checkpatch HEAD $PDIR &>> $REPORT_FILE
	cp $KCONFIG . &>> $REPORT_FILE
	make olddefconfig &>> $REPORT_FILE
	echo "===== FULL COMPILE =========" &>> $REPORT_FILE
	make -s -j 4 &>> $REPORT_FILE
	echo "===== SUB COMPILE =========" &>> $REPORT_FILE
	make -s -j 4 W=1 drivers/infiniband/ drivers/net/ethernet/mellanox/ &>> $REPORT_FILE
	echo "===== SMATCH =========" &>> $REPORT_FILE
	make CHECK="$SMATCH -p=kernel" C=1 drivers/infiniband/ drivers/net/ethernet/mellanox/ -s -j 4 &>> $REPORT_FILE
	echo "===== SPARSE =========" &>> $REPORT_FILE
	make CHECK="$SPARSE" C=2 drivers/infiniband/ drivers/net/ethernet/mellanox/ -s -j 4  &>> $REPORT_FILE
	popd &>> $REPORT_FILE
	rm -rf $PDIR
	git worktree prune
	# TODO: separate checkpatch errors, sparse, smatch
	NUMB_OF_ERRORS=$(awk -F": " '{print $1}' $REPORT_FILE | grep ":" | sort | uniq |wc -l)
	echo "There are $NUMB_OF_ERRORS errors/warnings"
}

do_one $SHA1 $REPORT_FILE
------------------------------------------

Thanks

[1] https://git-scm.com/docs/git-worktree

>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD



--oXuB1DDkBcw8yjUl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloP4KAACgkQ5GN7iDZy
WKdXghAAovQgEU2AB3dDY/ps8OE/ciVizkKjCu2jYNJkZNtszIbDKHvqUVd9lBUE
KaMCtq4FnJpp7oSPVm9KvfDiRJnaTgvLUComgiUYUO8AbNmuQA7xJ+/Jbq6iOJx5
IPvqqnljlOpWfg3sEFSA/W6MPN/NeQw+D3ngdhBt1S5AA8/oZ1Xn3UKcRwSNL6Pa
tbQSs0pT5VYIFCLH7NghL/TJ1WiJVWNEyON01kL9AlmaULqb09NjtnH9+Adhqf+p
M0ZJM7L8l0Wr+VKzV2+FHYRSsaH1K3Gk0ZqApSLf+L4C57JcVNENQ9NsIDdlSznw
k+6KyILCGO7zuFKFzihssIhLr/MX6zJb9Iep0dp+FVcp7wafw2gzKDbMKazkJeTC
ICJQikxSncAZYHeJa45BMk9Rb/DhwNYSPbthBjqzNteKJwFtESRuEgLWh/hb0/H3
wJMgXBMRgA0DtVi7ffj4FEUt7xHckaXcRhLn/4Z0/NO1HQky912zpdX4isDk6+c6
0GYXAznvXbF3nPkEC2nw76n+piL1WoZq8axqRi7TyJUj24WLdg6C5mqoR7H6VkOC
4bI+VDTwwsouaqbraYHp8swEY8PqrtWlqLNHBmGVK/CRHVf0cYJuRC2CcFfIsufp
3njXM9aFKVOZ3B5zrDd5E21WtEwFcgC74DZwLf6X6Cs+E9pbpi4=
=m+gx
-----END PGP SIGNATURE-----

--oXuB1DDkBcw8yjUl--
