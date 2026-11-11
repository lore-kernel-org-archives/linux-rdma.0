Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794403471;
	b=GYR30pnZDssYqIk2N6eiFBo1uQuYFcB1TXtxJIqVugCCbW5eQStkOatOXH0ClBJeP6WG
	 3Nn/C7ZU0xhTfrr/6+ZjlPDLaNiBZtiMRf3dAx7GYgxMNEFtYaSt7IUNCEjXJGiL9IsIM
	 vUfLquLmHqhl/Ct9nvcoLP2n8Hle+OMeap2rIJrdxdEFAEj019IHXyzNgWGFrFa5FpVoK
	 Vaif/E9erULrBSh7yLzFGb4q8RdRj9hhrV/pj8aaSgAY7qqMcO7hlCPd2fFDlSN9c2w4O
	 Hmx3f11tWG3QBqlpwCITpoxdU4kdBgYamT20eFwAEyZyU2F0+ZsK2EUMF79YBsO1Riw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794403471;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=uzBaz5jqtl18woVrXcDmQuaoa5Gf6nHDZaCA6adJaRY=;
	b=iCBpJkfTNpZ8bBwizHs+JFix+4wr7G9KqVs88ZIHkONw6g/6yGGTtQ3G5NrqWUZEDH6F
	 ZEChI59hLkiE6mZB2b4upC+daVdh39i/oTEo18qyS8kQVcEZso8RoUKCvqN5IAMotI27c
	 IJhv+yIUob4lXj220r0kuasxGlBabda6r2i3AqBS4ScJK81YhnWAM5r59hkIoPfmSdMeU
	 B19u3vA53ZFPRvBu4AAvHJObChsD0PJQhDzRZAn9OIM7UPXAE0pGXPjnODpCJE17GbvE8
	 d5rNK7JAYnVN+p7zuhoZ2ecySNHXl1qXouV04SYa2yL8kwopQyWdyCTHwfBZV8dLn8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="fr4/J+rb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47EC606A326;
	Wed, 11 Nov 2026 13:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fr4/J+rb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990891F00A05;
	Wed, 11 Nov 2026 13:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794403471;
	bh=uzBaz5jqtl18woVrXcDmQuaoa5Gf6nHDZaCA6adJaRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fr4/J+rbVpzt6DQkkQiR6yzcftvRYJwzkFC/K0BNN1VTaQU+A0Q04os/ez+QhIduw
	 bBnlfKh7kS9w73r/mlNHsjgUAuiz90TS99PGTqxa0FOzbGlq3m6qTTlOUwItArVBiz
	 tZC+S3fsZd0pO2QSvH/gzfdJkA2nXxTp5KoWI0jUbsoItWliafGB4NymWjbLX4LDy6
	 bcxqjr1uGyBC84g0UNd59CodBCcMfWBA9xa/K7ZaCwyh767lCEtookjhQLgJ3oppdU
	 aG65hs+MQNO2QMpHMiRSgBYlcKjg0LBbhC6C95ldQdXDBswmopdRgpUypiZyS/9ink
	 +8KUWrchviyvw==
Date: Wed, 11 Nov 2026 15:24:26 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/6] IB/isert: fix the device removal use-after-free
Message-ID: <20261111132426.GR8635@unreal>
References: <20261104040318.1844865-1-yhlee@isslab.korea.ac.kr>
 <20261104142043.GG478286@unreal>
 <CAM+FBJen6v58uZPvSTfSG--9r9LzwAp1PBWbWK7RUFM89qmMJA@mail.gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM+FBJen6v58uZPvSTfSG--9r9LzwAp1PBWbWK7RUFM89qmMJA@mail.gmail.com>

On Fri, Nov 06, 2026 at 08:26:49PM +0900, Yehyeong Lee wrote:
> Hi Leon,
> 
> Sorry for the flood of versions. I should have waited for review instead
> of reposting every time the bot flagged something. I'll stop here and
> won't send another version unless someone asks for one.
> 
> For what it's worth, each version was tested on soft-RoCE with KASAN,
> racing device removal against connect, login and teardown. I don't have
> iSER hardware, so none of it has run on a real HCA.
> 
> If it helps, I can send 1/6 and 2/6 on their own, without the stable
> tag, and leave the rest until someone can test it on hardware. If you'd
> rather drop the series, that's fine too.

You should get Acked by from isert maintainers.

Thanks
