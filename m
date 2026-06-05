Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186DD43E4A6;
	Fri,  5 Jun 2026 19:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780688275; cv=none; b=Myg5cLzG3wmW9AFXOaz+dWE3jJ7ZZ1J72PW8/L016DBtMlSooQbnH3f/9MFg6I1wxo1i+JcaO+kAex4oqhom/gosm6mkVDN7Cj2SwRp2miDwmhnO9jvrs5svnnJTsSnfUgpyBFjIy+/WvGY29SFUXySYjpApx+W5UNH/oLlhdLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780688275; c=relaxed/simple;
	bh=PpME3o5V3q/AO5KvgabF8eylQMra9FJR5/1IMqkJYUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3361zIaoYlH23X7Q/xeBEXnXsmTOJaEZIrVhiaZODxNYfw/eA1k3rQlsYyxC3ogRuZoMpoQcGn7GbVniTTvbQzQG5zwZ++fwG+ENxgXEz/AJVWaAOgqBPXK2Yd0atr7tqfFXFC8b+WYc7VCrhKhVtCr0H4uwrWWHZZ3IAHRnCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Af785c+4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Af785c+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB671F00898;
	Fri,  5 Jun 2026 19:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780688274;
	bh=GLotKGV1kavKVuKP/Zy1OFsCxYQdyASFbMsRhbq+uT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Af785c+4p8zDEMy/B7d1LVkI25MmdpILxbpYtqWS07gRa6iwzLvin8T/uK+bhAFqP
	 QMQjcKMg2M2GxVJbfvaOGg5eugyNMKy3B49ku9utqP5/+iJHOiOXEeeW0TkTD4wY4r
	 3U8O7ERHIIppocZd/v/60vYs4IUJCQwLIhx85ZeRYuJYoCslDKnwOSAmbdKA7IXUh+
	 tKvdLWgwY1FIvIk2FRW9Wr+7rRJZFZ4iIVUXnfj8SVMSJrzp/KQ3s3boBAqvw1M2JP
	 yccohWdAlG/yLf9uUVXXjglqkMOllXiA+DAxvO8AW3GrNBS+OuFIGP2ebu1RUNXVdj
	 2XjoxDrjqO2CQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Doug Ledford <dledford@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Haggai Eran <haggaie@mellanox.com>,
	Kamal Heib <kamalh@mellanox.com>,
	Amir Vadai <amirv@mellanox.com>,
	Moni Shoua <monis@mellanox.com>,
	Yonatan Cohen <yonatanc@mellanox.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zhu Yanjun <yanjunz@nvidia.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Vladislav Nikolaev <vlad102nikolaev@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: Re: [PATCH 6.1] RDMA/rxe: Complete the rxe_cleanup_task backport
Date: Fri,  5 Jun 2026 15:37:27 -0400
Message-ID: <20260605-stable-reply-0020@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603132729.423-1-vlad102nikolaev@gmail.com>
References: <20260603132729.423-1-vlad102nikolaev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [PATCH 6.1] RDMA/rxe: Complete the rxe_cleanup_task backport

Queued for 6.1.y, thanks.

-- 
Thanks,
Sasha
