Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D5B3C455C;
	Thu, 16 Jul 2026 09:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784193169; cv=none; b=hhZfkHzo9tKMn44W64wU4he04JV9Jj5VqPqtpvA3/lw1uMprgWdqFvDH6MC3UqPuS5fw8AeiSSh9uVmbcWmg4kkluYiss9IZHVbVHfohkjmVQEzb2v7q1I+m568j9hWqCCfMubFJiBaPfnTIMyg4iuu36SEpJhAmUk9FO8Ygn7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784193169; c=relaxed/simple;
	bh=AV2P90VDnbiWoUjItZmx5zFqzXhouo5I3agEl1sxGX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HoVYkI+S9wdnv93rgYFZAG7iEQqs8ze9y/ULmpLw9qJSrnPYNDHL7qLNrDSW4pvGOr5oIFYbnSYk68AD+2aCbOdbLVGmP9sw1hIWEb7HKZ2t57ONu54fDjcRqGGRWygl413Ti7NWxBWyk0JyfePD1wuMXnWqQEtYPi6L7QhC+5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lDMljzRE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lDMljzRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36901F000E9;
	Thu, 16 Jul 2026 09:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784193166;
	bh=+BQB/ESlogiZtwHgXb/1e34efnfHpTqZaIR7CJQpNbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lDMljzREJSi2k9DNq4azf1GxlsgrSpJ2GWW+UnqTu3fm82sXkBYYZHmVlA/C3GJG0
	 9I8Q/fyK5GjLWx8335rvwhtv9pUztrc6oxBmvRA/SEZ7nrXjxcXq6fzVnvNg4b0XaV
	 d4H6wU7ea3Yakk+gp17PqaTKVXlAr19DwhET4Tkch0H1N8JM9WThNbM3jXz5JmG4Za
	 u80pFuxBbN4bCffuLPBx/7DAWIWrqyyj7aQVUV7t51lG3b+2qjTUQInD7peoRtJze7
	 aIF0oELUY8Vfs/2AaoUlyELYsXIy1WY14DriYzDgD3JTu1aw48uieZ0GDeWXIjJ0p1
	 e0dWbiYWZgZFg==
Date: Thu, 16 Jul 2026 12:12:41 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Konstantin Taranov <kotaranov@microsoft.com>
Cc: Konstantin Taranov <kotaranov@linux.microsoft.com>,
	Long Li <longli@microsoft.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH rdma-next v3] RDMA/mana_ib: Adopt robust
 udata
Message-ID: <20260716091241.GB357857@unreal>
References: <20260714123113.3792099-1-kotaranov@linux.microsoft.com>
 <20260716084848.GD70906@unreal>
 <DU8PR83MB097533EE534834691DE5AB9DB4C72@DU8PR83MB0975.EURPRD83.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DU8PR83MB097533EE534834691DE5AB9DB4C72@DU8PR83MB0975.EURPRD83.prod.outlook.com>

On Thu, Jul 16, 2026 at 08:56:27AM +0000, Konstantin Taranov wrote:
> > From: Leon Romanovsky <leon@kernel.org>
> > On Tue, Jul 14, 2026 at 05:31:13AM -0700, Konstantin Taranov wrote:
> > > From: Konstantin Taranov <kotaranov@microsoft.com>
> > >
> > > Enable the uverbs robust udata interface in mana_ib by setting
> > > uverbs_robust_udata and converting the driver to the new udata
> > > handling model.
> > 
> > Why didn't you set ".uverbs_robust_udata = true" in this patch?
> 
> I did set. See the changes in drivers/infiniband/hw/mana/device.c

Thanks, it is unclear to me why grep didn't find it.
