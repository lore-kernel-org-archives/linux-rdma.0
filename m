Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E46A2F1FDF;
	Wed, 29 Jul 2026 06:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785305708; cv=none; b=I0rU9qxq1dC8MJRRsvkYKgxwvJnnmHgvEfu0fw57dF981rzn+OywZ3w5fC40M1e6/pLJZggfu3eNqw3wfPWl/5rc0K+sfp8fDLDTCOAHi8GQTCFUBQ6M8A0zki11Lsu3iBFf6vrlije1T81AcBgIIyDL5wIKxSTfK5BYVSG3kd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785305708; c=relaxed/simple;
	bh=Dyz6tGY6B3aaF93zhwMg2q7MWVE9jLXxpLiL3NiMJ4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KKHJ9YjH5Vk7giE0lSA29r3PYZd2szlF6n/Nq9bRzqUdI7IJcyaLdzn++hLR7AyjKNjb1ZPdm3R0ESEfinAvptlt4SXRSpavnKQjwEMhP5kES+zNYYmtlC50kOmRB5S5pvbYPJ4Ql2Tm5MCT3NctrABzu8+DYRJqRbwWJmVfyHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=VQVGSqgV; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="VQVGSqgV"
Received: by linux.microsoft.com (Postfix, from userid 1204)
	id 99B5C20B7166; Tue, 28 Jul 2026 23:14:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 99B5C20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1785305685;
	bh=sY/yKp5MJMHtbiEF0TrBRS5ReV7Q7c3RY1ClyW70uQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VQVGSqgVDvQDpHktoSYuyCgimSHuB5mCg2xyqINx5tjs9hDwXyXCa6hO9GtXKgbDc
	 Fa6jaWCSnHZ2+jNg5Wwsau42RGAT7sWvj5bTjSW81kxKKuTj8/PzLNckSx5OQO00gW
	 4MdtUTXVawxuhpVUrGZYXv54Oeu/kFRNuKQSHRlw=
Date: Tue, 28 Jul 2026 23:14:45 -0700
From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, leon@kernel.org,
	longli@microsoft.com, kotaranov@microsoft.com, horms@kernel.org,
	shradhagupta@linux.microsoft.com, ssengar@linux.microsoft.com,
	ernis@linux.microsoft.com, shirazsaleem@microsoft.com,
	linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	stephen@networkplumber.org, jacob.e.keller@intel.com,
	dipayanroy@microsoft.com, leitao@debian.org, kees@kernel.org,
	john.fastabend@gmail.com, hawk@kernel.org, bpf@vger.kernel.org,
	daniel@iogearbox.net, ast@kernel.org, sdf@fomichev.me,
	yury.norov@gmail.com, pavan.chebbi@broadcom.com,
	schakrabarti@linux.microsoft.com, gargaditya@linux.microsoft.com
Subject: Re: [PATCH net-next v12 4/4] net: mana: recover port on attach
 failure in ethtool operations
Message-ID: <ammaVReMMz+W22Gy@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260711041415.3008868-1-dipayanroy@linux.microsoft.com>
 <20260711041415.3008868-5-dipayanroy@linux.microsoft.com>
 <d2014044-d410-466a-ae66-2a173dbdba82@redhat.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2014044-d410-466a-ae66-2a173dbdba82@redhat.com>

On Thu, Jul 23, 2026 at 12:18:22PM +0200, Paolo Abeni wrote:
> On 7/11/26 6:10 AM, Dipayaan Roy wrote:
> > When mana_attach() fails during ethtool ring size or channel count
> > changes, the port is left in a broken state with no recovery
> > mechanism, requiring manual intervention to bring the port back up.
> > 
> > On VM SKUs without a netvsc fallback interface, this results in
> > complete loss of network connectivity to the VM.
> > 
> > Fix by scheduling queue_reset_work when mana_attach() fails. The
> > preceding patch ensures mana_detach() always completes its full
> > teardown (netif_device_detach + cleanup), so the reset handler's
> > mana_detach() takes the "already detached" early return, preserving
> > port_st_save for a successful mana_attach() recovery.
> > 
> > When mana_attach() fails, choose retry values that maximize recovery
> > chances: if the operation was an increase, fall back to the previous
> > working values; if it was a decrease but still above default, fall
> > back to defaults; otherwise use the minimum supported values.
> > 
> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Tested-by: Aditya Garg <gargaditya@linux.microsoft.com>
> > Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
> sashiko gemini sees quite a bit of problem with the above approach:
> 
> https://sashiko.dev/#/patchset/20260711041415.3008868-1-dipayanroy%40linux.microsoft.com
> 
> Also, changing user-setting in case of fallback is quite a bad thing to
> be avoided.
> 
> Skimming over the code, it looks like than pre-allocate all the
> resources and to a replace instead of detach/attach() looks feasible. I
> suggest investigating such path. I also think that this last patch (and
> possibly 2/4) could/should be in separate series.
> 
> Finally and most relevant thing; AI review comments should be explicitly
> acknowledged by either debating them or addressing them. In both cases a
> reply on the ML is expected.
> 
> /P

Hi Paolo,

Thank you for the review.

Accepting the feedback on 4/4 and working on the
pre-allocate-and-replace approach you suggested. We are discussing with
the HW/NIC team and investigating pre-allocating the queue resources from HW
while a set already exists, as with this patch we are trying to handle
and recover from failures caused due to HW/NIC resource exhaustion for
queues.

I will drop 4/4 from this series in v13 and stick to only the ethtool
private flag changes. Will send out a separate series for the problem
currently discussed in 4/4 once all the above points are concluded.

For 2/4 I will send it as a fixes patch to net as it will be common for
all functions calling mana_detach.

Regards
Dipayaan Roy
