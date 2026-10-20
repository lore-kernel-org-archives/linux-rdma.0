Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792470652;
	b=m/iXbPSTKTLvYm+4gkWcp04YnsWgN52GT/25nk8/I1v2AksOqV7QeNaBnTdAf+XxEGkV
	 PuXzx4n6wCHf6szJjXQZqtVujjiFYSxuTZZd/66DBLc17xB40ME5Z8Me/gXEefDpIzsoX
	 tLBg720RlOZRIRuybcYKvfPSQ5HJjltu8P5WQuSLTTv8tIfPP4/6xSEt/PzgYbucHVxLh
	 zGh8gWVlu17Uv1bQhhTZ5fhWLrlFD0HgZyor16VZsQVYiySiGzeYgxUx8szS/R320tDSy
	 g/pqBYQrFi+GakVa3FiaP9PUSKJiZV7uX3bRZ4wsQxfjI3Iblpxx2Oz4kutq06HWeaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792470652;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=GUy/xzBZGPagZZn/WQck+ql2UBUZUe5Sbx3c/m790fs=;
	b=ZHbilL7AcBS1T3QsfBUu1dqCIhB3+MeXJqJSWiUAOlA5C8RUMFwxnYsG5DTl2z4MoxHo
	 IsMnjyWosJ0fVln2XUVPju6RQv0HGLnVhlG0k+m7l+YS8d4WwvJ3RcYmGHFI5zbuKXqLC
	 YHFlf2/JtsOWgTTC8V1uzMxIJffUwT8D0QzMzvE1CupxP+VvpkSFjCZWFMnrYthOMX0d1
	 9wpi+8pNSi/LCqs6ksoCO+S7JzhQQaMlghMFzwIewdfzFX99d2dVO576zpVrV0EDHRTGo
	 djTdysJuxJ4bHejZmUeQeE6yVUKjX582TecdEyjIijvJRmjy9XkLVNotM1nevCF4+Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=quQjRj6c;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 702E8606A334;
	Tue, 20 Oct 2026 04:30:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 702E8606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=quQjRj6c
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id D772020B7172;
	Mon, 19 Oct 2026 21:30:43 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D772020B7172
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792470644;
	bh=GUy/xzBZGPagZZn/WQck+ql2UBUZUe5Sbx3c/m790fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=quQjRj6c6EZvljRRnAfURE4+hQoQx4Q5gCFslrhfUW4j6jdKJNR6kdI2u+KS8Ta1V
	 may3NWnVufFkgqY0gZaEXSyM1FjA//KEUMd5BPuVlk4kMtT3SOJWWSe34VOJN21WD+
	 4UYjtMjtZ6botHve74ebtkD5z6lHNySUMlGd+Qug=
From: Wei Hu <weh@linux.microsoft.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	weh@microsoft.com,
	kuba@kernel.org
Subject: Re: [PATCH net-next v7 06/13] net: mana: swap queue sets in mana_set_priv_flags
Date: Tue, 20 Oct 2026 04:30:41 +0000
Message-ID: <qset-v7-sashiko-06-v8-plan.20261018.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-175606@kernel.org>
References: <cover.1791710735.git.weh@linux.microsoft.com> <c1a2032792858ac0234807bbb5b26b81af4d10b1.1791710735.git.weh@linux.microsoft.com> <sashiko-outbox-175606@kernel.org>
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
Content-Transfer-Encoding: 8bit

Hi,

> Does this code introduce an open-coded trylock pattern?

I will keep the existing synchronization in v8. channel_changing is a
vport-admission reservation protected by vport_mutex, not an unprotected
replacement for the serialization of Ethernet reconfiguration.

RTNL serializes the Ethernet reconfiguration and reset writers. The
reservation remains set while the rebuild releases vport_mutex between
individual vport operations, so concurrent RDMA admission through
mana_cfg_vport(check=true) can reject that interval under vport_mutex.
The success and failure cleanup paths clear the reservation under the
same mutex.

Holding vport_mutex over the whole rebuild is not a drop-in replacement:
the vport configuration/unconfiguration helpers acquire it themselves.
The report does not identify a missing exclusion edge in the existing
protocol, which is also present in v6. I am not redesigning that protocol
solely on the basis of its resemblance to a trylock.

Thanks,
Wei
