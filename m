Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B790437EFE2;
	Tue,  2 Jun 2026 20:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780432989; cv=none; b=FglpsKoUc/hOWJ8gloRUQ8knrErdG1BhWm8GUy1WxT4rUSFq0H+/c9huAnLKdfg9CnayVw6Xd0nFIq7Mm9/PwGKarDCpJ9/zsn+PFJM4/j/mB3tl4Uw5lRdqPqKVkJjA4q1owA98btFuwGXYKILNl7RjwVpJpHZRlhB9/YO9hGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780432989; c=relaxed/simple;
	bh=2O1gcP/d7udlYJtNzKmFYrF+js+Ih2nWNSmX65Ge+5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u46MPVu21b8rzkZdNJaPE+FYun8E9HuUWm19ePHBMlxUsLWWVbagPtjgcbbwZ3O1jvS9PAtnaU5Kldu87O6RoajuALhQnXSKo7/VxOThFJDOJuZdan2hEFV4k6f3kPoFRO4PRoFEinEIjfKjGy+6rC5kmJ18npC+arV/Xe6qCcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=OkPvqQq7; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="OkPvqQq7"
Received: by linux.microsoft.com (Postfix, from userid 1204)
	id B84C720B7167; Tue,  2 Jun 2026 13:42:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B84C720B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1780432974;
	bh=YfXavZAnhgEX9wJtH9QZrsFlIDVXx/maWlD8Y7IYFuk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OkPvqQq74OHaaGRag7dgVGGkyZdqn3ksIm7UUEfQS544c2EErEdSZ8AghWOEXnpHu
	 Hq9iSy+lvH8g8tkw+FBB0YifTfiqS7FrKUyIhtoofgokafFZKsMtG6lji5GV15LsG6
	 I6G83Jk5tamZcqBgr8SskbKMkTjpKSJnaX45rcAE=
Date: Tue, 2 Jun 2026 13:42:54 -0700
From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, pabeni@redhat.com, leon@kernel.org,
	longli@microsoft.com, kotaranov@microsoft.com, horms@kernel.org,
	shradhagupta@linux.microsoft.com, ssengar@linux.microsoft.com,
	ernis@linux.microsoft.com, shirazsaleem@microsoft.com,
	linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	stephen@networkplumber.org, jacob.e.keller@intel.com,
	dipayanroy@microsoft.com, leitao@debian.org, kees@kernel.org,
	john.fastabend@gmail.com, hawk@kernel.org, bpf@vger.kernel.org,
	daniel@iogearbox.net, ast@kernel.org, sdf@fomichev.me,
	yury.norov@gmail.com
Subject: Re: [PATCH v8 2/2] net: mana: force full-page RX buffers via ethtool
 private flag
Message-ID: <ah9ATqI3dsAJiW/P@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260508115100.488506-3-dipayanroy@linux.microsoft.com>
 <20260512022133.856196-1-kuba@kernel.org>
 <aguFpq8+LV+I9oH0@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ahkAG/EN2YhKIKpi@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260529105739.5fc5fdf5@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529105739.5fc5fdf5@kernel.org>

On Fri, May 29, 2026 at 10:57:39AM -0700, Jakub Kicinski wrote:
> On Thu, 28 May 2026 19:55:23 -0700 Dipayaan Roy wrote:
> > As the pre-requisite fixes patches are accepted now:
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=17bfe0a8c014
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=5b05aa36ee24
> > 
> > Can this series be merged now? Let me know if it needs a rebase or
> > anything else.
> 
> If there's any dependency, functional or otherwise on the fixes you
> need to wait until they make their way to net-next.
> 
> Otherwise you can rebase and repost now.

Hi Jakub,

I see the fixes have landed in net-next. So I rebased this series and posted as v10.
https://lore.kernel.org/all/20260602202801.1873742-1-dipayanroy@linux.microsoft.com/


Regards
Dipayaan Roy
