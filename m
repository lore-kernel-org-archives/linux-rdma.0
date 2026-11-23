Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795468113;
	b=ueJ1f5maJQcvEooVQnUSZttBFYH081Z25fhyVRPTFaGYxgM6fFqlD+dcasFUFBT73fNT
	 /mTrKFs7S8C5TEgLe6UnDOpnEhyQcm7w06ZhXNv/PJdSmvD14JNCUbbO4hZzWxiPtA7It
	 V6G3Eg3ExV7BYkxsewizIyYbKPp8TjGenWCTXY99KbjqcGy06ZBvBrAdnoFbhSZzaGbU8
	 kfa5jlYIcEs+IXkaInTXbd+vqQqCjtpvQxz3uHPXD4is/szwxFstIXA4G4HkusOBs74r6
	 Mk4odJk0oLRXZk1n/CGUUBHmgXxbPBykx7tPC9rWL7/Z7Ih5SspQ1bGeZoknpDMdaGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795468113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:X-Patch-Reply:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=EO4uQX/7/bcKRhbS3udTzj/oZQeNEQAhUDG89AzCYmg=;
	b=J2VztNhsipZiCbVeQTuYED5clAj58gfigsLB6nsbdofFriqmuPVfOkksPhO4Tmi/QFEm
	 0IBDyWrg7/DUNusfJhv7Z6GzknywcOptp51U/WA7RYxbkccXYJuMolEqbl35GJr5mna3Y
	 egyfU0nE7Lwktr0sfOAk1hPsdx1xiz6SIaaEtGNZfbiuvwV+cE0/taODIe/wETghkjq2z
	 VErF1+2pqku1n4BqEB798HLQDPPhJHCjygj0L+qN3JgH00a1aFhzEINQ9k7Y5mYutCyrw
	 ceq3uSF2379eMJQDjsgyQCqq6eh0qMPk8TbEJGSGpNbMfNboNuVOrI+jyoKsb3thprQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B9dR51uW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE88606A321;
	Mon, 23 Nov 2026 21:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B9dR51uW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4341F000C0;
	Mon, 23 Nov 2026 21:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795468113;
	bh=EO4uQX/7/bcKRhbS3udTzj/oZQeNEQAhUDG89AzCYmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B9dR51uWHHhVnYeoZ2b4EvD3DV6CDpRIaSZhavQoeKruWyn1VjlSYp3z0MeMmFXIz
	 dnxJWN2Y0emDlLuOHTboMMkrbMYjxXnaq3k0REAyZI1OvKFPwA6db2/GxgbdlAzRm9
	 ydq/AvG8zu+YusmwusMa1b4x17S9r3VNddXatiLNlvXjvPXCA2+KQGOkf3KS1DhOHv
	 eLM9kyw1pTzMksWmMXLOoYMQFA8ElQIhN9JEwbYziCv28+U6Ems49iEwONKwXOcxaw
	 QQOJhe4FhLpbrp7JTxw4M9Im4vjuRRgX7XZAd1K+qVE2EzQokJPT2rdhirXOJ6JtFd
	 r5E2LY9yoMYAg==
From: Danilo Krummrich <dakr@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Mark Bloch <mbloch@nvidia.com>,
	Amir Tzin <amirtz@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gal Pressman <gal@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH V3] driver core: auxiliary bus: Fix IRQ sysfs directory cleanup
Date: Mon, 23 Nov 2026 22:08:26 +0100
Message-ID: <20261123210826.1625426-1-dakr@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261112081319.3466442-1-tariqt@nvidia.com>
References: <20261112081319.3466442-1-tariqt@nvidia.com>
X-Patch-Reply: applied
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, 12 Nov 2026 10:13:19 +0200, Tariq Toukan wrote:
> [PATCH V3] driver core: auxiliary bus: Fix IRQ sysfs directory cleanup

Applied, thanks!

  Branch: driver-core-testing
  Tree:   git://git.kernel.org/pub/scm/linux/kernel/git/driver-core/driver-core.git

[1/1] driver core: auxiliary bus: Fix IRQ sysfs directory cleanup
      commit: b0404f6af48d

The patch will appear in the next linux-next integration (typically within 24
hours on weekdays).

The patch is in the driver-core-testing branch and will be promoted to
driver-core-next after validation.
