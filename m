Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792680258;
	b=ilsOdoniqiP648eBXVCOCc+gUi4zDT7FvFk89HsPBgwCS3Ad6LwEzY42OJ7WLpBlE2RU
	 8HigcjgfwKxv5VwcHIGHtr/v5JyxVjI2dL5LZ2hVGHnsafzfaLGPQ3rC1i5Ujpq4cONGS
	 i7iABQlXxsdahqOyT+zUATkwexMiQhGEeL0tuXIqMdFuPhMSl+MG6YfEbRXiC861P9Ela
	 ZLHpnAUT4mtkyE3n77dVthY0/XS6EH0gnubSSRj09oDETZQPfbPGprtecAgEDBPKCGe8Y
	 20kEHzkx7UT5I/WPYUexe4+zBK0BKMKG6zE9zSGaDANr0bByZ43O1DM9fnuJNW+wcLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792680258;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=WLA04YGmvJYf4ztBr1aZyMGrcsH9UVf2VtyeG0AJuUQ=;
	b=jP9sOLqupsa891ifBwRzI0xosEJ95qqx+nKSkWfT9pk3LKEqOYhBuoKEvn0wA/ndnHrQ
	 4VtbwLSIWizirEkMB2mbnFikpW3mrjLw5ReCixXYy/lb5WG6KE+dmlpNq13sgrh5+25XR
	 0/2SuEjpxL8KeDPOMeSnzZD6TP/w0cr/ZYB661cVgXkHaDZd047P7ZwjPQXHW1PdEzEqb
	 PqPH8YnthqThWG6ArawqPJIWvh2Hgs93hg7smoFLZLhaI8iydR2InNPEqKawn0l7lqiVG
	 vTByL4lRxGtpeGvsE8jNVNufFvGdD/lS1lpre6lr7p4nANUgCYdQF+OKWkej0tKq3EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=GAl7K4+U;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C51AE606A327;
	Thu, 22 Oct 2026 14:44:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C51AE606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=GAl7K4+U
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 52A2520B7168;
	Thu, 22 Oct 2026 07:44:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 52A2520B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792680249;
	bh=WLA04YGmvJYf4ztBr1aZyMGrcsH9UVf2VtyeG0AJuUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAl7K4+UQNW5IIqFXqg1ctHU6sR0MyK/VlmN/N4Xi47DZykpYLZuId4AY1UswkxUW
	 T1UPK/JN6fdt9UeKdHGHjHzHabXKEGisW4wH8eQvX4d77fUXV+4Yk+2WrIkAPEdTcp
	 Eg33sIXJHJqfBhQOyuMVKK32DuMgWuUsRVCUpXw0=
From: Wei Hu <weh@linux.microsoft.com>
To: netdev-bot+sashiko@kernel.org
Cc: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gargaditya@linux.microsoft.com,
	kees+treewide@kernel.org,
	kees@kernel.org,
	mawasthi@linux.microsoft.com,
	weh@microsoft.com,
	edumazet@kernel.org
Subject: Re: [PATCH net-next v8 2/4] net: mana: give each HWC message slot its own completion state
Date: Thu, 22 Oct 2026 14:44:08 +0000
Message-ID: <hwc-v9-v8-review-20261022-patch2-b09e6c742e9b326f8dde@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <179250339038.3135.16651240191139289948@kernel.org>
References: <6e6a337c466b86d93c52ea0adb5c7121ea3e9a7e.1791998462.git.weh@linux.microsoft.com>  <179250339038.3135.16651240191139289948@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Thanks for the review.=0D
=0D
On Tue, 20 Oct 2026 13:36:30 +0000, netdev-bot+sashiko@kernel.org wrote:=0D
=0D
> This isn't a bug introduced by this patch, but can this memcpy() read=0D
> past the end of the RX slot?=0D
=0D
This is pre-existing in the baseline driver; we will address separately.=0D
As noted in the review, patch 4 already bounds the requested response=0D
size by the RX slot capacity before admission in the completed series.=0D
=0D
> This isn't a bug introduced by this patch, but can a late response for a=
=0D
> timed-out command be delivered to the next sender that reuses this=0D
> msg_id?=0D
=0D
This is pre-existing in the baseline driver; we will address separately.=0D
As noted in the review, patch 3 already keeps a timed-out slot reserved=0D
until its pending response is consumed or teardown retires it. That=0D
protection remains in v9.=0D
=0D
Regards,=0D
Wei=0D
