Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E368013B7A3;
	Tue, 17 Mar 2026 21:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773784449; cv=none; b=ha9WO+mFo77xz2YIBgc/k+m1n8kNLb5qlNfy0YtSI/hOOVxeb1683MtE5ijPE1Q7OriiIoI4l8HrKuk2wF5jiMZO45OUW12PBG4waZNhqrR3O+uAw9/Pe+YUeelhbky0WVzY9ktm1PjrDMkcjv6VwYhY9giNVOqzrNVo+/yaQa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773784449; c=relaxed/simple;
	bh=+aR42J36uhJrB5PKeHnzhQaVlsl8gxIqMtR/iL7GlXI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PzGd8/hsgxMcvFHkTbmty+qAuskBq97qbIirAb07+/sSzZ+uvPW+QfrREKhNxeOi9Y6wizY/KzrssucSqY1RAgfRsv3IEKvqQXVqQQAemtntSv40V1DpqNawX7hO/ioPFL0pkzErHUtFYJGYo/enHfd6pvNfo/m6fWwehSsqvic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gSKIvBKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gSKIvBKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B425C4CEF7;
	Tue, 17 Mar 2026 21:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773784448;
	bh=+aR42J36uhJrB5PKeHnzhQaVlsl8gxIqMtR/iL7GlXI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gSKIvBKFJ8ehsTp88qZHnKolnfCNU9n3x9KsZcKh4wT046FpIleebUppRaHs6VUoT
	 u2QIBqHu0J8vtexULb+Da2A2EJg1hGZFGG4MyxIBLZoRDRCPCVpq+EQWyAbejArywu
	 OmXH/zQCDhJ5T4rwso3+1V9HF07wzh5h/E7LXISxd3zmffxKpiONfKQJzfn53a28wg
	 EC3jvpSMz7xaU4QzaRKz8wYEdOsHgNfJrgGQmr3T9YGQs0c3PAzU7ypE1ARvLeAa7p
	 zS195rRa4vv5D8jJ3FlcJX9yMHHcSeQ1t0WEFW+9O4BqYwpvlq5pjQwJ/kGOjAOZ5E
	 pyuHP5dUBNi8A==
Date: Tue, 17 Mar 2026 14:54:07 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Allison Henderson <allison.henderson@oracle.com>
Cc: "achender@kernel.org" <achender@kernel.org>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
 "shuah@kernel.org" <shuah@kernel.org>, "rds-devel@oss.oracle.com"
 <rds-devel@oss.oracle.com>, "horms@kernel.org" <horms@kernel.org>,
 "edumazet@google.com" <edumazet@google.com>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next v1] selftest: rds: add
 tools/testing/selftests/net/rds/config
Message-ID: <20260317145407.244ee071@kernel.org>
In-Reply-To: <d33e764e33b5a4c6464a692371afc41d4a01c15d.camel@oracle.com>
References: <20260316235848.2395654-1-achender@kernel.org>
	<728fc0aa-4c07-4092-91bb-6b9f76c2f3eb@redhat.com>
	<d33e764e33b5a4c6464a692371afc41d4a01c15d.camel@oracle.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Mar 2026 18:26:10 +0000 Allison Henderson wrote:
> On Tue, 2026-03-17 at 15:41 +0100, Paolo Abeni wrote:
> > On 3/17/26 12:58 AM, Allison Henderson wrote:  
> > > diff --git a/tools/testing/selftests/net/rds/config.sh b/tools/testing/selftests/net/rds/config.sh
> > > index 791c8dbe1095..7cf56ee8882f 100755
> > > --- a/tools/testing/selftests/net/rds/config.sh
> > > +++ b/tools/testing/selftests/net/rds/config.sh
> > > @@ -24,7 +24,7 @@ while getopts "g" opt; do
> > >    esac
> > >  done
> > >  
> > > -CONF_FILE="tools/testing/selftests/net/config"
> > > +CONF_FILE="tools/testing/selftests/net/rds/config"
> > >  
> > >  # no modules
> > >  scripts/config --file "$CONF_FILE" --disable CONFIG_MODULES  
> > 
> > This looks wrong?!? The script is going to update the config file which
> > is under git control. You probably want to copy the default config in a
> > tmp file file, edit the latter and add it to .gitignore and EXTRA_CLEAN.
> > 
> > The issue looks pre-existent, but since you are touching this part...

Well spotted.

> Sure, so config.sh isnt actually called by anything within the self
> tests or testing harness.  It more intended to be a stand alone tool
> for when developers want to enable/disable gcov.  If you like we can
> adjust the target to a rds/config.local and copy rds/config there.  
> 
> CONF_FILE="tools/testing/selftests/net/rds/config.local"  
> cp tools/testing/selftests/net/rds/config "$CONF_FILE"
> 
> Alternately we could simply have the script default to config.local,
> and add a parameter that allows the caller to specify the config
> path.  Let me know what you prefer.
> 
> I may split off the config.sh changes into a separate patch so that
> Jakub can start using the config though.

How do you actually use it? Presumably we should be modifying the config
used for build directly not a snippet.

By default scripts/config will already use .config in current directory
which should be what people would want 99% of the time?
We can add --file to the script to select the config user wants to
change but keep the default of not specifying the file hence .config?
