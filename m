Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792680261;
	b=b7+na9I3UKW9FHfjKhAt46Wr0jDFW0mKUuVJtz9Fzw1Gd0nOtbjAbhbOQM71RNRqfaRj
	 /HiSMrPom5/m8j67Qa0v0ZNYEnG0llckHYZvDtqRMK8tV33SU25CXmKIQlS0BEgHQBJjM
	 b7kytvU7NZg7YlFaEiW+30Fv9td33WC0+MzATdeUq6XxPWEZYTTf5dFbi9gpr3aS5g/5J
	 uc4YxQpGzUu6d6LZQ6s2J8ag3OO7wU7xvqVm2nVkOdX8/BlpQtOLbW4bFBImi7UE+ZvYH
	 D3lQHfy/LqWacGLIWsdH3LNg4DT3oSVgOhFKnHPn8KY3iclajG6kS+rbrtntu195Vnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792680261;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=2G/tkT9b682VBEXOE4r7jWgUbyMAXcNgbFTNw9JLs5c=;
	b=mBg6zv0ujcEc3qam4iZyB4w/HakrisxesQZ92Mm4FZ6l4pfPpAgRSdUcIO9IB5P9K3pW
	 PZ11kzsTZA2rxwuZxD9V1+F0136uAJ8LNuEtxcvLTGp+DdBQa1+k/HDKJbkEfHUtn4l1D
	 jhPBzu2hgilA0FNpSBasXxEf9JPPbFV58wsgZGQSrrNoFIj8yRG/L3npojfYA5u+n8XYW
	 BmQEXynsp50qvMg3WzAFsXMpVYV/5TBnERj5Rb16cjxehUw1V6uiV73grd1OFYC7ag0DR
	 bo7HCyUzyb+IRV5Yku9sVlNeXxlLDWRi+4D6NNrJOhYjmAuoWGOVAnaU+hWnQV7Xpqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=Jk603uyp;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B859A606A33F;
	Thu, 22 Oct 2026 14:44:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B859A606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=Jk603uyp
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 382C220B7167;
	Thu, 22 Oct 2026 07:44:11 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 382C220B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792680252;
	bh=2G/tkT9b682VBEXOE4r7jWgUbyMAXcNgbFTNw9JLs5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jk603uypHxVp7JE/awAWc6xwGFQD5OwIBxSBC7toug/eo8qvauKAOXu5cXzI+w790
	 lm0xfwYW16LZbzwE4nUyy9n83nRuBExcrlmK4FK1ijz4lo9h8yyHMhPip1dhXINO0j
	 apeML4PteM0tmwS/XepwvDAmBVZjRsnv4sHqyNtY=
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
Subject: Re: [PATCH net-next v8 4/4] net: mana: add dynamic HWC queue depth with reinit path
Date: Thu, 22 Oct 2026 14:44:10 +0000
Message-ID: <hwc-v9-v8-review-20261022-patch4-545e64b8e0aba06c648a@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <179250339474.3135.8335532818248262678@kernel.org>
References: <877e674c0255820b0517f863e535615b4028a48a.1791998462.git.weh@linux.microsoft.com>  <179250339474.3135.8335532818248262678@kernel.org>
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
On Tue, 20 Oct 2026 13:36:34 +0000, netdev-bot+sashiko@kernel.org wrote:=0D
=0D
> How does the PF learn the size of the rebuilt rings?=0D
=0D
The PF specifies the HWC queue depth and corresponding ring sizes. It=0D
reports the required depth via HWC_INIT_DATA_QUEUE_DEPTH, and the VF=0D
rebuilds the rings to implement that PF requirement.=0D
=0D
Regards,=0D
Wei=0D
