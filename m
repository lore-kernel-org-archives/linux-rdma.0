Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7218828C2BF;
	Fri,  8 May 2026 22:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778279696; cv=none; b=AVJNo7UPD/TUUAQ54fziw7bYMdsfors6uEvHfGNyqhzWbzjYN7+lVXML9G+r9J7ZQRr3YGbm0udAqA1FMC76egUNviIk1gpGdtXORQz7wZO51hYSgDLcGgnqaAGs2tXVRl5O4XGEt5/GttOfm1hBowWrs83mf/Vt0j3ii5WGJQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778279696; c=relaxed/simple;
	bh=/FqJRBmfOok3Fl/V8liHSdXMD9qTqHxPKI6+SAyQksw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FG+5USePfJOf2rNhGp8rZEIoYozGow4AtXAgXsSsR+cJrRBXF7Q7xJMbjaZ0J7XCQlpNl2QU3sKwEZt85aIEPG+XERZPt247QvYscoXHOpPb8rA1KJWLJtuXCVgngZ5v4SruE0CmB2TJIcf0YrQQYhKYde4NgyP8+2Ipceu07Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JnJD8Wpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JnJD8Wpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF80FC2BCB0;
	Fri,  8 May 2026 22:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778279696;
	bh=/FqJRBmfOok3Fl/V8liHSdXMD9qTqHxPKI6+SAyQksw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JnJD8WpuGcqHBCKs0Ts4elbdxBbuG1BwAgscLJuNVRziMOm4SDnzTqN3kx1yP6/X+
	 GAdeAqIhI9nFlzVHTLX/S1mwIbo19SrwK0wfDhJeidejvlNcoYDlK1SrT/oiL3UYj0
	 GIekbaJ56hBFjeEkBXBs+ZV1/MchvLrAP41b6RvmgIFAwNZnLqYwRd6dO+6HhbJbJd
	 kxC8LBO1S3SVunqjOv2Wtp8A5+8SXmiVHrPTOd/+4hirtqSKiT2/3p3ywrNsL4bTOE
	 TJfm7z3NUrn0fQCLaudtHO7mA8dPHCWP88gD1VhxYK4rvad70qNKJD/NatwmvbNDwF
	 jyVcPI/fAlqow==
Date: Fri, 8 May 2026 15:34:52 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= (The Capable Hub)"
 <u.kleine-koenig@baylibre.com>
Cc: Michael Grzeschik <mgr@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Marc Kleine-Budde
 <mkl@pengutronix.de>, Vincent Mailhol <mailhol@kernel.org>, Krzysztof
 Halasa <khc@pm.waw.pl>, Johannes Berg <johannes@sipsolutions.net>, Steffen
 Klassert <klassert@kernel.org>, David Dillow <dave@thedillows.org>, Ion
 Badulescu <ionut@badula.org>, Mark Einon <mark.einon@gmail.com>, Rasesh
 Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com, Manish Chopra
 <manishc@marvell.com>, Potnuri Bharat Teja <bharat@chelsio.com>, Denis
 Kirjanov <kirjanov@gmail.com>, Jijie Shao <shaojijie@huawei.com>, Jian Shen
 <shenjian15@huawei.com>, Cai Huoqing <cai.huoqing@linux.dev>, Fan Gong
 <gongfan1@huawei.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek
 Kitszel <przemyslaw.kitszel@intel.com>, Tariq Toukan <tariqt@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Mark
 Bloch <mbloch@nvidia.com>, Ido Schimmel <idosch@nvidia.com>, Petr Machata
 <petrm@nvidia.com>, Yibo Dong <dong100@mucse.com>, Heiner Kallweit
 <hkallweit1@gmail.com>, nic_swsd@realtek.com, Jiri Pirko
 <jiri@resnulli.us>, Francois Romieu <romieu@fr.zoreil.com>, Daniele Venzano
 <venza@brownhat.org>, Samuel Chessman <chessman@tux.org>, Jiawen Wu
 <jiawenwu@trustnetic.com>, Mengyuan Lou <mengyuanlou@net-swift.com>, Kevin
 Curtis <kevin.curtis@farsite.co.uk>, Arend van Spriel
 <arend.vanspriel@broadcom.com>, Stanislav Yakovlev
 <stas.yakovlev@gmail.com>, Richard Cochran <richardcochran@gmail.com>, Kees
 Cook <kees@kernel.org>, Aleksandr Loktionov
 <aleksandr.loktionov@intel.com>, Thomas Gleixner <tglx@kernel.org>, Jacob
 Keller <jacob.e.keller@intel.com>, Thomas Fourier
 <fourier.thomas@gmail.com>, Ingo Molnar <mingo@kernel.org>, Kory Maincent
 <kory.maincent@bootlin.com>, Zilin Guan <zilin@seu.edu.cn>, Vadim Fedorenko
 <vadim.fedorenko@linux.dev>, Marco Crivellari <marco.crivellari@suse.com>,
 Bjorn Helgaas <bhelgaas@google.com>, David Arinzon <darinzon@amazon.com>,
 Yeounsu Moon <yyyynoom@gmail.com>, Denis Benato <benato.denis96@gmail.com>,
 Yonglong Liu <liuyonglong@huawei.com>, Andy Shevchenko
 <andriy.shevchenko@intel.com>, Randy Dunlap <rdunlap@infradead.org>, Yicong
 Hui <yiconghui@gmail.com>, MD Danish Anwar <danishanwar@ti.com>, Nathan
 Chancellor <nathan@kernel.org>, Ethan Nelson-Moore
 <enelsonmoore@gmail.com>, Larysa Zaremba <larysa.zaremba@intel.com>, Ian
 Lin <ian.lin@infineon.com>, Colin Ian King <colin.i.king@gmail.com>, Double
 Lo <double.lo@cypress.com>, Markus Schneider-Pargmann <msp@baylibre.com>,
 Simon Horman <horms@kernel.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
 linux-parisc@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
 linux-rdma@vger.kernel.org, oss-drivers@corigine.com,
 linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH net-next v2 0/2] Rework pci_device_id initialisation
Message-ID: <20260508153452.6a1a9044@kernel.org>
In-Reply-To: <cover.1778149923.git.u.kleine-koenig@baylibre.com>
References: <cover.1778149923.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  7 May 2026 12:50:18 +0200 Uwe Kleine-K=C3=B6nig (The Capable Hub)
wrote:
>   net: Consistently define pci_device_ids using named initializers
>   net: nfp: Drop PCI class entries with .class_mask =3D 0

There's a transient build failure between these two patches,
you should probably reorder them?
--=20
pw-bot: cr
