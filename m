Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CE4371D08;
	Mon,  1 Jun 2026 12:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780318725; cv=none; b=rLAUFs3kC+6Zl644CyZWLrZjOnFGGdED6hgSDZosCul3EPaY2SfxtXTrmtpQ0I+L89TJJ74qmyp5Vq4NL2WSGurc0DciKuIvbrV0hfUEUYq4sZvJ1MX9kYo5N+SxE4LvgBTHUx1ZwNOUAt91nUKBst8Me8JpoPud2btNiE8P7Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780318725; c=relaxed/simple;
	bh=6Y5HJCUfZOnFUQa4AatktWigr2XfKiuV2TQs0zIUxQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9G0pGdc7erakn/YZhCyuiYUMmTvYxjE1WMa6NXT1FxXYRWvZ7Dh0fa+Rwu5X0h0j/M4imgKbvfmvOQD0R+j/SmE4E6Seh6CZTUH4vsU5sMSnUUm9BH+6+FgWchiPoBU8WMV6xOjT1HY4MnDUOLofQSWvmQYODTMOHSNwboGJEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MYNNB4HN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MYNNB4HN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC2D1F00893;
	Mon,  1 Jun 2026 12:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780318724;
	bh=P7rDevCZnFjkWVTnN7LsLiTYCzqFkr5n/NYFmJGjz+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MYNNB4HNONIG/b/z1lxMw17uWiLW2/iSk8HouiQQvxi78qlWwzikTRMoBb7l90tSz
	 +yALZ1WhIRogzCT/8TU7Yy+fASCh5FyB1xSuLK3blHn8EH3qy6eCJS9oDlpMHSRB4y
	 TDjG53L/Kwzksych4gwMlq6pL8BLvpllYnskDDR7eAgmh4C/vbryfSnxlVSc8YmJy6
	 tvKxgulPJKf9Mv9rgVVkVa2WWULCoSijzdNE94pKHd7szHUoVI6B2nNROge7Q8qnOE
	 HslnChmi3f0sBiU1naABH6YB3OZRAn9+OklyQ9LHPg7pKObukwMF0pO0mTMUffKf37
	 NqOvD3uNTumXw==
Date: Mon, 1 Jun 2026 13:58:38 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Laight <david.laight.linux@gmail.com>,
	David Matlack <dmatlack@google.com>,
	Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 06/11] selftests: Fix arm64 IO barriers to match kernel
Message-ID: <ah2B_mzQabiEYSWt@willie-the-truck>
References: <0-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com>
 <6-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com>
 <ahiFxtmspbETiqWw@google.com>
 <20260529134947.GA128816@nvidia.com>
 <20260529175516.06d5788f@pumpkin>
 <20260529192933.GD3195266@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529192933.GD3195266@nvidia.com>

On Fri, May 29, 2026 at 04:29:34PM -0300, Jason Gunthorpe wrote:
> On Fri, May 29, 2026 at 05:55:16PM +0100, David Laight wrote:
> > On Fri, 29 May 2026 10:49:47 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > 
> > > On Thu, May 28, 2026 at 06:13:26PM +0000, David Matlack wrote:
> > > 
> > > > Let's put these in tools/arch/arm64/include/asm/io.h so that the tools
> > > > headers are more aligned with the kernel headers, and so that the arm64
> > > > io.h overrides are done in the same way as the x86 overrides in
> > > > tools/arch/x86/include/asm/io.h.
> > > > 
> > > > Something like this (untested):  
> > > 
> > > Okay, the disassembly says it works:
> > > 
> > >     1db8:       ca080108        eor     x8, x8, x8
> > >     1dbc:       b5000008        cbnz    x8, 1dbc <readl+0x58>
> > >     1dc0:       f9000fe8        str     x8, [sp, #24]
> > 
> > That looks strange, I suspect the C didn't match any usual pattern.
> > Normally 'tmp' would get thrown away and 'v' would get kept.
> > But you seem to have discarded 'v' and written 'tmp' to stack.
> 
> Oh interesting the optimizer isn't turned on for selftest builds. So
> the str is dutifully writing tmp to the stack. Another register has
> the actual value.
> 
> > I'm probably being stupid again, but how does that work?
> > The cpu can speculate straight through the control dependency into
> > the following instructions.
> > An 'eor x1, x8, x8' may not even have a data-dependency on x8.
> > (Most x86 cpus just generate a zero for the equivalent instruction.)
> 
> I can't say, this is copied from the kernel and Will made it:
> 
>     arm64: io: Ensure calls to delay routines are ordered against prior readX()

This is specifically for ordering counter accesses against prior
barriered MMIO reads. Userspace should really be using the vDSO instead
of accessing the counter directly, so you could probably drop this for
the tools headers tbh and just have the dma_rmb().

Will
