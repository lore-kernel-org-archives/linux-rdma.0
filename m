Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FB130E0F2;
	Sat, 12 Sep 2026 01:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789176277; cv=none; b=GbZUyXR7B7xchE6pNUcm2ZWHWWAx8mwG61kzfv0meTPlBc0gJt+Nn4PHgc+30Ouw6GhKXyTjbHuxDrfRaonViZEFGRhg8xq818R5Sdwusdy5VFDy5hjsqf43VXTPRyIJnXDfvEnAjHHBuDH0aQpmk0qgcOfu9j+mAem0kFfKAic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789176277; c=relaxed/simple;
	bh=LGd6dC0onm1ajNOz0Cb9Sk/OoQsDF8Ak9Js6QeKb3MQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LJN/oQagl7ACsFlQko8tAtbvhdWHeiiNyuuiXCB7i1et7XOBqvzMyn+whKd+hBGuy4Cv7J//mcST69F8Asix1Y6vtRr/MmuKiE184E9D39UssX+BbYoOJjTNNLubTRREW5eqcVM1ZCQVhHN9Wlzf3uA2uFXHsWWRuxYu715Nu+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oginf3Tq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oginf3Tq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6F31F00893;
	Sat, 12 Sep 2026 01:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789176275;
	bh=atCJ+9fOMZNoJYAqBKF0xAZjFgYfz6uFc9U9AXB0XEM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=oginf3TqeM7uCTnaSK2SuDV+DseeP0B+iIawaCsqfcOcAEPw2/T8BBJDHEWf0Mati
	 mPhpcn0XpCJi8wE/4/udMj2SARyDzkmA9AYn0l0wTxxAQfANYVpFnMXh/iznjjcdFw
	 wnxVbH3bd/pttFp+27YjeW4LlOpBwhpT/LXOvPFVUQIb0k5OxXYCks7+0dVz9aaFbv
	 8pdyk/77wDjhk3s9UQH5StrqOgjAffRsyWSTq62xHsouY5JEA1eUNRmg5ygfdk5kKE
	 nzbELUoF/3YwotA7INyEkPByUamJTwudlxPxHqbj87t17xO8HUiqKxv8hWlq/OpSLU
	 RQHWGTYsWknAg==
Date: Fri, 11 Sep 2026 18:24:33 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, Sabrina Dubroca
 <sd@queasysnail.net>, Bobby Eshleman <bobbyeshleman@meta.com>, Boris
 Pismenny <borisp@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin
 Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan
 Ozturk <doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
 <gal@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, Kees Cook
 <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Petr Machata
 <petrm@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
 <rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
 <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
 <horms@kernel.org>, Willem de Bruijn <willemb@google.com>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next V4 14/14] selftests: drv-net: Add PSP HW GRO
 conformance tests
Message-ID: <20260911182433.74d3f73c@kernel.org>
In-Reply-To: <20260908065244.3799142-15-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
	<20260908065244.3799142-15-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 8 Sep 2026 09:52:44 +0300 Tariq Toukan wrote:
> From: Cosmin Ratiu <cratiu@nvidia.com>
> 
> Add PSP conformance tests using the same gro helper binary as other gro
> tests , but in --psp mode. SPIs are procured by psp_gro.py from a real
> PSP device and handed off to the gro sender & receiver. The sender
> crafts and encrypts packets in software, the receiver relies fully on
> the HW to decrypt, decapsulate and do HW GRO.
> 
> Because the NIC decrypts and decapsulates before the frames reach the
> receiver AF_PACKET tap, the gro receiver sees the plain frames and the
> assertions remain exactly the same as other gro tests.
> 
> So these tests verify, at length, that the device does PSP HW-GRO the
> same way as plain TCP.
> 
> Additional PSP-specific tests are defined to check that GRO doesn't
> merge packets across PSP versions, SPIs, encryption-status, etc.
> 
> Some gro tests are not included because they don't work:
> - ip_csum: the checksum is recomputed by psp_dev_rcv().
> - tcp_csum: packets are marked with CHECKSUM_UNNECESSARY.
> - ip_frag4/ip_frag6: PSP is incompatible with IP fragmentation.
> - IPv6 extension header tests: PSP doesn't deal with IPv6 ext headers.

Daniel commented on the csum tests already, it'd also be good to
understand what the problem with frag tests is. Presumably they
get passed thru still encrypted? Or dropped and counted as errors?

> diff --git a/tools/testing/selftests/drivers/net/hw/Makefile b/tools/testing/selftests/drivers/net/hw/Makefile
> index 6105be8e590f..daa7e52f236e 100644
> --- a/tools/testing/selftests/drivers/net/hw/Makefile
> +++ b/tools/testing/selftests/drivers/net/hw/Makefile
> @@ -13,6 +13,20 @@ else
>  $(warning excluding iouring tests, liburing not installed or too old)
>  endif
>  
> +# psp_gro.py uses the gro binary in PSP mode, which requires OpenSSL.
> +PKG_CONFIG ?= pkg-config
> +HAVE_OPENSSL := $(shell echo 'int main(void) { return 0; }' | \
> +		  $(CC) -x c - -include openssl/evp.h \
> +		  $(shell $(PKG_CONFIG) --cflags --libs libcrypto 2>/dev/null \
> +			  || echo -lcrypto) \
> +		  -o /dev/null >/dev/null 2>&1 && echo 1)
> +
> +ifeq ($(HAVE_OPENSSL),1)
> +COND_PROGS += psp_gro.py
> +else
> +$(warning excluding PSP GRO tests, libcrypto not installed)
> +endif

Looks like slop. Why do this? Just run the test and see if it works.
Don't hide the python tests because build was lacking. We explicitly
want to see all tests run and fail if something is missing in the build
setup in NIPA.

If you really want you can "probe" or display the support in some --help
message from the binary and check at runtime. 

>  TEST_GEN_FILES := \
>  	$(COND_GEN_FILES) \
>  # end of TEST_GEN_FILES
> @@ -40,6 +54,7 @@ TEST_PROGS = \
>  	nk_qlease.py \
>  	ntuple.py \
>  	pp_alloc_fail.py \
> +	$(COND_PROGS) \
>  	rss_api.py \
>  	rss_ctx.py \
>  	rss_drv.py \
> @@ -64,6 +79,8 @@ TEST_FILES := \
>  
>  TEST_INCLUDES := \
>  	$(wildcard lib/py/*.py ../lib/py/*.py) \
> +	../gro_lib.py \
> +	../psp_lib.py \

ugh, just move the test down to the drv-net dir, and Xfail for
netdevsim. Both PSP and GRO live in ../ better to keep this test
there as well.

> +# Tests for both IP versions, a subset of gro tests. Missing:
> +# - tcp_csum: PSP packets are validated by HW (with the ICV) and marked with
> +# CHECKSUM_UNNECESSARY.
> +_COMMON = ["data_same", "data_lrg_sml", "data_sml_lrg", "data_lrg_1byte",
> +           "data_burst",
> +           "ack",
> +           "flags_psh", "flags_syn", "flags_rst", "flags_urg", "flags_cwr",
> +           "tcp_seq", "tcp_ts", "tcp_opt",
> +           "ip_ecn", "ip_tos",
> +           "large_max", "large_rem",

Really not great that we have to duplicate all the cases under psp.
Narcisa is adding BIG TCP cases for instance, how are we
going to keep this in sync :S

