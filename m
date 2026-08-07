Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF17437EFE7;
	Fri,  7 Aug 2026 22:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786143041; cv=none; b=qqfP5rVS5Au8um0421BW0G/4Qn5DrmDkSo1T7yZ+Ylc2lBy1hL2GEhBezzk9OCrxyKvZay4wQcnHPAqthPnWDVXmIi/FiToK6pN4geqoId+RogxcoNJfvcr+5t6MDykr59lXKXAWbhcC5Z8CN8u6TTOVYcRdXN/dgsy/9aSyxRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786143041; c=relaxed/simple;
	bh=VM0ducLUDYaNygeoBptsE2LptsL7CZQtJwSwp3E5fyA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hna5/ryvrkcWJa8m6iLbWSE4OqRe7KSvdMw30QM1Wu2IQT4umuJT5yfCErZ4SfXPw0pMTTkQFm3mHhuFOe/6cqq2Df5h++mpr9NaXKZvTuYNYG0rhVHE5cWlYZv0bT6YICx1Txl8m06ZDtqXGW9nchLC6ARQy3kBpyzv7kePXpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oe8VM+s4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oe8VM+s4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E21C1F000E9;
	Fri,  7 Aug 2026 22:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786143040;
	bh=JBSGXkp/uI2pJHkaqY1LBS7/gVaCRReAlARxnDhIL6U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Oe8VM+s4oFzx/n8T2UrgVWJ5KpthhNqvYM1VauwjblD48jhg4OSmvtxefCyp/8UdG
	 MBWwolfpdggYKpX6gQCw1M74b5wwss5MqrkpVJGtxaiu6/0y50ft5Cg9hfsJNjc7Uj
	 XHKaQn8r9ELvvpba5yku4dEaYeksYM/04X3DmbT5EyMhBXh+KVBFwLq7fdEZhETe9Y
	 QgjxhF6YhROcgqJmugWizqVwZLo4OSI1Q9nKstFhZ3ZTU2ptcakSYhycRAzpGT8Pjy
	 yE6yFXrrva2sI0J8FvcgkDdzvzbtxqgNC4HE8LXnjEU3jxJAhaG2vJpgnzBrx1Efv8
	 1iKCPQwZPkehw==
Date: Fri, 7 Aug 2026 15:50:38 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Hidayath Khan <hidayath@linux.ibm.com>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 wintera@linux.ibm.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, wenjia@linux.ibm.com,
 mjambigi@linux.ibm.com, tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
 horms@kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
 agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 pasic@linux.ibm.com, gbayer@linux.ibm.com, andrew+netdev@lunn.ch,
 netdev@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] dibs: fix double free of dmb_clientid_arr
Message-ID: <20260807155038.4c48fc54@kernel.org>
In-Reply-To: <20260806120447.596164-1-hidayath@linux.ibm.com>
References: <20260806120447.596164-1-hidayath@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  6 Aug 2026 14:04:47 +0200 Hidayath Khan wrote:
> dibs_dev_add() frees dibs->dmb_clientid_arr on both of its failure
> paths, but does not clear the pointer. dibs_lo_dev_probe() then frees
> the same pointer again in its err_reg path, so a failing device_add()
> or sysfs_create_group() results in a double free.
> 
> Drop the kfree() from dibs_lo_dev_probe().

This should be squashed with Alexandra's fix.
