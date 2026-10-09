Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1798F4A7CA0;
	Fri,  9 Oct 2026 14:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791554559; cv=none; b=uzRxFivOZmjPoCsJ/+4VabTvh7W7afmZSDCWoGRr8WzMCHqj3lb3323xqi/W0/4qF3slfPtWBEVyOGn2rOz0lAmY7ldeGu2uuq9ckKmS5i4fKmPESbcAjB920VVRFK4JZnNDjxNbthO9hy417wJauEGbooWOZP2FS0IYUBg0MmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791554559; c=relaxed/simple;
	bh=mCkVLQfZtkzK5qWr9x++mYNAOI6TCbMF0LdzlPs+BzA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dyGL9YVITZrfggiVJivzExBnpgDYRptj00SQks4mr9xiPXZhUxiVsHZn0a0FkyRcEAhBCSR4XmmWDt/hLG0wHHV+dXKbfUQ6/UuPDhvBkQBGFFmfH8D8ZxUyQCpAygu4bzr0XwMybmjPCXm42c6t57N/NpmixyRNzK+UijH0Ukk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Ow+rR17V; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Ow+rR17V"
Received: from [10.26.7.43] (unknown [4.213.232.23])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5669520B7168;
	Fri,  9 Oct 2026 07:02:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5669520B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791554549;
	bh=o9/j7BPe/uob7m93Mq91i/EDR+z+f/2g2cs0hIlqrfc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ow+rR17VHN66CP5vqGHPQQoCf/Oeb/NQtkum7i0SYvROjHBqwp1JFIORapqfV663h
	 h4MWr3uJNcwVvrLdPeiubFErYneVsVGO9ebbXQjffLCGMhz42W3N6xpCQV7MWvMxqn
	 hrATrpbOPAp1KpSzaGup+NMauQsio3zXN8OavxMk=
Message-ID: <bdf19a74-d4b3-4fad-946b-4911546d1a70@linux.microsoft.com>
Date: Fri, 9 Oct 2026 19:32:23 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] net: mana: Add support to process throttled EQEs
To: netdev-bot+sinfo@kernel.org
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, kotaranov@microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, gargaditya@linux.microsoft.com,
 mawasthi@linux.microsoft.com, leitao@debian.org,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261008083315.306076-1-sahilchandna@linux.microsoft.com>
 <179144878753.2527009.17917144229253595701@kernel.org>
Content-Language: en-US
From: Sahil Chandna <sahilchandna@linux.microsoft.com>
In-Reply-To: <179144878753.2527009.17917144229253595701@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 08-10-2026 14:09, netdev-bot+sinfo@kernel.org wrote:
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.
> 
This issue was discovered internally>  - Whether the issue was actually
triggered, or is only theoretical
>    (e.g. found by code inspection). If it was triggered please include
>    the symptoms, like the stack trace or error messages.
> 
Logs:
2026-10-03T05:29:01 hv_netvsc eth0: VF slot 0 removed
2026-10-03T05:29:23 mana 7870:00:00.0 ens1: NETDEV WATCHDOG: CPU: 45:
                    transmit queue 1 timed out 15133 ms
2026-10-03T05:31:05 mana 7870:00:00.0: HWC: Request timed out: 60000 ms
2026-10-03T05:31:05 mana 7870:00:00.0: Gf stats wk handler: gf stats
query timed out.
2026-10-03T05:31:21 ens1: NETDEV WATCHDOG: CPU: 20: transmit queue 0
timed out 15859 ms
2026-10-03T05:31:37 ens1: NETDEV WATCHDOG: CPU: 15: transmit queue 0
timed out 31731 ms
2026-10-03T05:31:53 ens1: NETDEV WATCHDOG: CPU: 21: transmit queue 0
timed out 47603 ms
2026-10-03T05:32:08 ens1: NETDEV WATCHDOG: CPU: 42: transmit queue 0
timed out 62451 ms
>  - What hardware the change was tested on. For driver fixes please
>    mention the device (and if relevant firmware version) used for
>    testing, or say that the change was not tested on real hardware.
> 
This was tested on azure arm64 VMs while running Virtual Client
(https://github.com/microsoft/VirtualClient) with busy poll enabled.>
Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
> 
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.
This is a feature being enabled to handle a new EQE type 4 hence chose
to send it to net-next
