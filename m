Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793817468;
	b=Kc7zYWZtbeayIJHjwfp2yqOEGNb58TP360R2z6+v6FJDfbQ2lJfLwU0JD6+V/4rXkwiX
	 gGgrsGgpSnHUhXm5pZ8Qyd+jXVW8csKzaKFNvNE6IuINw2+qFbVH45TU9voSMT7Z9z643
	 7ZVhWjAt68PH5E142cQ1c0Bro8y/dgeJD9Kccj3LvWfPAVOUd6gn473LhCmjkOL5JItcS
	 FvPUoufUHbE2449edxS9ENfwLHJ1v6H/IokxyItync+qHRkb3qpwnfAVH1Y+2qOlSmIcS
	 WVFCEeK3xDfagzpV8GKdWfUHmEWYm9i08BtlCI5iG/osztLHp360GxiqRuhPzjFlhhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	b=TZCk+L4UP8kUXRakmYh3CspwZnhBdU/fuk7wbypKh/mVaIYYGBeh6Hgm0stvdj8aGygi
	 IoWHhCLY0ZCUfnZsDnBj32TPKDME2ngIXIqRAPwLpgPEGdCoHPnHcY/coKi8DY6iUAuGw
	 0UkUvstlFLGW+2YEfiLHP+Cz4UwFNwyr55AW7XjZj7vmE07yBbngAChRhl7wKfiMLyUiI
	 TcxWsrDPz2v2/c9O1teSHWLSZEzb00gj7cRhtBlB+pC0bF5gz1mhLfX51sMNit/ZhGdlb
	 c52azvDDaKTKPryTpJUkDAf1KuEHy0AYEWHWfjKntJX917eitiTTGblmmDGTnCKRXsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UB3HSKHn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80235606A31B;
	Wed,  4 Nov 2026 18:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UB3HSKHn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112EB1F000C1;
	Wed,  4 Nov 2026 18:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793817468;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UB3HSKHndNp02XqZ99513CBnJaR6kWbphDvXElL3Ie7QhaWMx+cCa4bizVl/0mDMK
	 89BnsIqLW4jHchb8atHyf9cyMfXPmeqZHeGOqW/lKblIKDkQ1HAlNWWga3UM4o1pJb
	 XZtx/CcZTcMIwjqh7dUzH8COfMcwuqEtfJSCNTV69gefaQUsDBLE1oEftKgXXdPU7q
	 Z8kCqICEyFekZe0Bg2A6sM3vE0kHLOw639SjspxRrIMUtscYjjtL3/444Go/WkMh1n
	 b2gvrt4q4kaihLRXsy3JVpR+TYWaLUxKY0l3ba1U477Nx1FV8IeX61gfMJxH0HHaBr
	 X6LtSkspjjIMA==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Carolina Jubran <cjubran@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <markb@mellanox.com>,
 Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh <moshe@mellanox.com>,
 Richard Cochran <richardcochran@gmail.com>,
 Saeed Mahameed <saeedm@mellanox.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shahar Shitrit <shshitrit@nvidia.com>, Simon Horman <horms@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
Subject: 
 Re: [PATCH net V2] net/mlx5: Use only loaded devices for PTP clock operations
Date: Wed, 04 Nov 2026 18:37:46 +0000
Message-ID: <179381746658.488859.12055215608519756880@kernel.org>
In-Reply-To: <20261104183158.758314-1-tariqt@nvidia.com>
References: <20261104183158.758314-1-tariqt@nvidia.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
