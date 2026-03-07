Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F25C2DD5F6;
	Sat,  7 Mar 2026 03:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772854376; cv=none; b=nEMmfeKP5df/6O//xhsIYQCRl5B8jvhVxL+lOv/5Kp4UkB5ghoq5iXYW+GoTEDOdMKbVgDG2WVHnHDZx5375qEjW57SO0cOVYMK1BDsDcmwbYumF+sphbe9kpBFOINzgomfuDstDvPTN8pfYPNUv9pbsK8+zK+6WbDFv2lp+NuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772854376; c=relaxed/simple;
	bh=UB4aqVHBkq7Z6U0PCU86267heuJHua5cm31mgeVxY3I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XeBiXyw78tiQFs5MfApf+8vdLMKGom0epL5lEQ4b4PfyANrSDfeDRvU+lI7eOqM4IH5APNidQNrgirQJ4TnLqMHgSr2ffJH9U+ZA7LcBj3eJBe6wKjA5vqRx1gs1S+niU04oj3qOag1MbvexUDhSfPDtO2+hOoTaeWvyZc/WlEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lGyqRF/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lGyqRF/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69D9C19422;
	Sat,  7 Mar 2026 03:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772854375;
	bh=UB4aqVHBkq7Z6U0PCU86267heuJHua5cm31mgeVxY3I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lGyqRF/3qzEa7lUUuOdYRlHTYZ8SUHXAAJTLsEiatdGzW/HtZ0lre9XP1JLBn9FT4
	 FiB8d6JjDEBERM5v9dDKjL9ZRFWnIVKcKCTQRNG7/LAaP3Zzc6Lp3//EjpID8pnFBo
	 5e4K9pd3jXePOLfbQ0bga42/+X20Gs37yz3iGKGwbReGfvo40vSYXrE1bB/+hs79JN
	 MMDMX/wuV8tpMKLLtpSofe2S1yk+kr/shs1IGhF6wbU0DhCnRHIFxH+VE+EzBgOMHN
	 OVIU0NfXL/Uspb2E4ksgXotAe2pnN7Dlf5zwCRTtf9Yu9yGKT//AWVXjEX4wsf421L
	 i0ORcG8R3BMzA==
Date: Fri, 6 Mar 2026 19:32:53 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, horms@kernel.org, donald.hunter@gmail.com,
 corbet@lwn.net, skhan@linuxfoundation.org, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 przemyslaw.kitszel@intel.com, mschmidt@redhat.com, andrew+netdev@lunn.ch,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 chuck.lever@oracle.com, matttbe@kernel.org, cjubran@nvidia.com,
 daniel.zahka@gmail.com, linux-doc@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 01/13] devlink: expose devlink instance
 index over netlink
Message-ID: <20260306193253.6d7d2383@kernel.org>
In-Reply-To: <20260304160022.6114-2-jiri@resnulli.us>
References: <20260304160022.6114-1-jiri@resnulli.us>
	<20260304160022.6114-2-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  4 Mar 2026 17:00:10 +0100 Jiri Pirko wrote:
> +      -
> +        name: index
> +        type: uint
> +        doc: Unique devlink instance index.

AI complains on patch 6 that the index is truncated because it's saved
to a u32. Let's add:

        checks:
           max: u32-max

here and the policy will take care of the check, you can then remove
the explicit checks too
-- 
pw-bot: cr
