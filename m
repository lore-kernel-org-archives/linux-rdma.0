Return-Path: <SRS0=Zpop=AK=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99225C433DF
	for <linux-rdma@archiver.kernel.org>; Mon, 29 Jun 2020 20:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DD60206A5
	for <linux-rdma@archiver.kernel.org>; Mon, 29 Jun 2020 20:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593462802;
	bh=4rUMvl4W+0dTlzq+q81WLdOeKcSLdHqIVJI5237I3mc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=UgIAI4QS60TKQvDqRocgMi7cb9OL4Ag1E1sbC2Xkm8AqTzYybrZpMqYZ4JOqSvFvT
	 ZVjzJ4zi6DR70FaSSC7SFdidvb2kMngG9Wa0TCXuk2dbPKAyJYk6l3bDdcKM2yrX4Z
	 AMr4MXrUThcG2cZd0wCl4MXeqNECqt4c53Rq9XsE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389336AbgF2UdU (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 29 Jun 2020 16:33:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389177AbgF2UdT (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 29 Jun 2020 16:33:19 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4D1F2067D;
        Mon, 29 Jun 2020 20:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593462799;
        bh=4rUMvl4W+0dTlzq+q81WLdOeKcSLdHqIVJI5237I3mc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zgQrY5/yuwgMl4OySz99JGe3vZZdkHkdDFboCp/7XRCGy5s3VI8JveZcakEMjpnyZ
         +ej3yGrDl9TqTFMBsKP1sNIruwADprfk1hvX5x/+dXy1K+WpGjMUt4qfyawUu2hkb3
         a9ZQe/FHOQS0Xyv5l33V6AFubacuKFaULEyBzn3c=
Date:   Mon, 29 Jun 2020 21:33:17 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200629203317.GM5499@sirena.org.uk>
References: <20200520125437.GH31189@ziepe.ca>
 <08fa562783e8a47f857d7f96859ab3617c47e81c.camel@linux.intel.com>
 <20200521233437.GF17583@ziepe.ca>
 <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
 <20200523062351.GD3156699@kroah.com>
 <57185aae-e1c9-4380-7801-234a13deebae@linux.intel.com>
 <20200524063519.GB1369260@kroah.com>
 <fe44419b-924c-b183-b761-78771b7d506d@linux.intel.com>
 <s5h5zcistpb.wl-tiwai@suse.de>
 <20200527071733.GB52617@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TxukmIqg3MmZ0Kmh"
Content-Disposition: inline
In-Reply-To: <20200527071733.GB52617@kroah.com>
X-Cookie: Real programs don't eat cache.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


--TxukmIqg3MmZ0Kmh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 27, 2020 at 09:17:33AM +0200, Greg KH wrote:

> Ok, that's good to hear.  But platform devices should never be showing
> up as a child of a PCI device.  In the "near future" when we get the
> virtual bus code merged, we can convert any existing users like this to
> the new code.

What are we supposed to do with things like PCI attached FPGAs and ASICs
in that case?  They can have host visible devices with physical
resources like MMIO ranges and interrupts without those being split up
neatly as PCI subfunctions - the original use case for MFD was such
ASICs, there's a few PCI drivers in there now.  Adding support for those
into virtual bus would make it even more of a cut'n'paste of the
platform bus than it already is.

--TxukmIqg3MmZ0Kmh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl76UAwACgkQJNaLcl1U
h9DGrwf/dbx5iLf+Ih3TFEH8p4lVh+RAmaAC6LIvz+LoKryJqiE3ZNcSM5/4GPZx
C1f4Daud6UOLeFeB7mYI+soHS4RAf5GZ2BOFKBVdJrpDXGALgPQQ7pWTwMioV/BH
9a4gDpBDoEq9BExzZaJmUArvp2o4az9wmP6se2CNV24ofaW1ZAb6HjxYMslnRPeX
VaaW93oRtNqFwnU9gOdkeGE7xzz5ZQ2t44bCh9e/3sLw3YExSXEJ+uvsIKbbIiSj
AehNFW46JeKU9IwZtx6wSjKDbAaxNb1mSQWqArkLYcYuwpFHvGMwDt2OpteNcCpI
580QPw5rS5wmLtwVZgmI95OAhxaTJQ==
=/tbf
-----END PGP SIGNATURE-----

--TxukmIqg3MmZ0Kmh--
