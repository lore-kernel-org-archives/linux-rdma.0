Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 912FA274B28;
	Wed,  6 May 2026 16:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778086364; cv=none; b=f6ibGUOavbinFotsZDDJzZfRAtX2ZtDi5YUkltocgz+HJSmJxIUr3v0eKhfa45qlr5JP85symt32xeQoar0E/s/815Exs00ZC9UlCUc6yle2oT4ioPJmXoyTW+/BjUt3Diw/NARwZJvo8Kf5c7mgpmHreFNZfb/2g1tGSiOTP8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778086364; c=relaxed/simple;
	bh=zLgo2hlPL3BFc2poeW/lY/orC7GUuzmLfWWK1cnK3Yw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k/e1/RZYRA4ABGMm4AtJ0faH2Ymh2kPI9+oRz3TeuV+eAOTshpR/OEwdbhJadYGINK4i+RGyx3Ni0JRC+vVmYTv6QiFYUxyfvIkhXrHdEWUy4syewVI9j8G7M7hGkhA25boYr8ULxJKNktb27VMgRr7cSl2n2+dfcxSfoGJYMUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=UdmvDoKt; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="UdmvDoKt"
Received: by linux.microsoft.com (Postfix, from userid 1204)
	id 9531D20B7165; Wed,  6 May 2026 09:52:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9531D20B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1778086360;
	bh=PCz+S4dgNQoTGyML6uFElTl2NXVVtXB+dmI/tbDc9rc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UdmvDoKtA0Li2wRZEF0U8Ea6XMbMrIBKbO44mzbwqc017t05dcSwx+bEHku+eR+XP
	 +c4Xc9wmHW3DH57K81YhDHQDTSamHwEr6ZsyW9Kw0nUxErCDf0/ZghiwhZunkS9Dv6
	 TTtQjboUhEueYjX/iyXl2Yn7HzOYtvMOmDUceSZw=
Date: Wed, 6 May 2026 09:52:40 -0700
From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: David Wei <dw@davidwei.uk>, kys@microsoft.com, haiyangz@microsoft.com,
	wei.liu@kernel.org, decui@microsoft.com, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	leon@kernel.org, longli@microsoft.com, kotaranov@microsoft.com,
	horms@kernel.org, shradhagupta@linux.microsoft.com,
	ssengar@linux.microsoft.com, ernis@linux.microsoft.com,
	shirazsaleem@microsoft.com, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, stephen@networkplumber.org,
	jacob.e.keller@intel.com, leitao@debian.org, kees@kernel.org,
	john.fastabend@gmail.com, hawk@kernel.org, bpf@vger.kernel.org,
	daniel@iogearbox.net, ast@kernel.org, sdf@fomichev.me,
	dipayanroy@microsoft.com
Subject: Re: [PATCH net-next v6 0/2] net: mana: add ethtool private flag for
 full-page RX buffers
Message-ID: <aftx2E1ZARV55DrR@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260407200216.272659-1-dipayanroy@linux.microsoft.com>
 <20260409183509.0b24dea6@kernel.org>
 <20260412125917.4fa8fc8d@kernel.org>
 <ad5kuCZz+gR1TlSh@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260416083146.0bb94d2b@kernel.org>
 <aeoVC27mIzoKytqA@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <685d7bf9-062d-4bd2-8448-f7714bb05302@davidwei.uk>
 <aex119OtL8CEGXkb@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260427131745.2eac52ef@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427131745.2eac52ef@kernel.org>

On Mon, Apr 27, 2026 at 01:17:45PM -0700, Jakub Kicinski wrote:
> On Sat, 25 Apr 2026 01:05:43 -0700 Dipayaan Roy wrote:
> > Hi Jakub,
> > with this new data from David, is it convincing enough for a mana driver
> > specific private flag, which can be set from user space by a udev rule
> > by detecting the underlying platform? If not then I will send the next
> > version with the other rxbuflen approach. 
> 
> I think so, thank you both for the testing.
> Please look out for the net-next opening up and repost the patches.
> (The reopening is delayed, it was supposed to happen already but I
> can't get a clean run out of our CI, sigh)

Hi Jakub,
I have reposted the patches now.

Regards
Dipayaan Roy
