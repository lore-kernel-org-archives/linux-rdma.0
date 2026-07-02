Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A102F1FF4;
	Thu,  2 Jul 2026 15:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783007883; cv=none; b=S94WDAx5pAFumWzwl1NGXaIf4+7HeOLqbjtUHP+kLAR2UHafVDYuvmIX5bITWp6MCgggJShnIavoi5i6TDN8l+B+g8LPf+1Rp+t/KYzkCOPunRqtv0YpWMx92Xkh/JgUi4fz8gTawyHId/PwCh4wOhl7IB6vikv6xJmqsODrN/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783007883; c=relaxed/simple;
	bh=xLQZlGcrRQKBWU/T+lZQ4jgS7fH3b6kmKQmsUVndNSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AXEjSagITfmFCFitgl3zahZYYkGDsCLM1P1gkXgTiMN0LYT7RN07/JcmJqA5K2MnbxL6WWRV3BWDkVAwo6e47eQ2hzc2bNpeMZlr9O1Da6CfvqIIrnzpkuJfJLrvEbMO/f6ql2kCf+Dk/K15pmq5oLl5AcnGK8Bh2kygjOmzpxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJnNNRP+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJnNNRP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03FE1F000E9;
	Thu,  2 Jul 2026 15:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783007881;
	bh=2GojpbKbN4k2MdbuYx8HDDnbJJg9jcM6tSbyryOEvMk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SJnNNRP+EGmmhh6KRiH7vrp7U5tcCQ4uUkk74aV3dBETWeDGJ2fYnPrhWEpA4mIVF
	 a7YX2/PcQ1r9wtser/tab+01pWo35DpJF6WKp0qvZ0Uv0rU/X657DvwsQuIkVvEpqV
	 TtOxbKTWJHUe4wOVptSf0WzHL3aO90+5UHJi4or4=
Date: Thu, 2 Jul 2026 17:58:11 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Russell King <linux@armlinux.org.uk>, Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heiko Stuebner <heiko@sntech.de>, Xu Yilun <yilun.xu@intel.com>,
	Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Will Deacon <will@kernel.org>,
	Jiucheng Xu <jiucheng.xu@amlogic.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Kevin Hilman <khilman@baylibre.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Xu Yang <xu.yang_2@nxp.com>, Linu Cherian <lcherian@marvell.com>,
	Gowthami Thiagarajan <gthiagarajan@marvell.com>,
	Ji Sheng Teoh <jisheng.teoh@starfivetech.com>,
	Khuong Dinh <khuong@os.amperecomputing.com>,
	Yury Norov <yury.norov@gmail.com>, Kees Cook <kees@kernel.org>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Besar Wicaksono <bwicaksono@nvidia.com>, Ma Ke <make24@iscas.ac.cn>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Yushan Wang <wangyushan12@huawei.com>,
	linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-perf-users@vger.kernel.org, x86@kernel.org,
	driver-core@lists.linux.dev, linux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org, linux-fpga@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-amlogic@lists.infradead.org, linux-cxl@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2 01/11] arm: Use sysfs_emit() for cpumask show callbacks
Message-ID: <2026070244-flier-large-17d1@gregkh>
References: <20260702154725.185376-1-ynorov@nvidia.com>
 <20260702154725.185376-2-ynorov@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702154725.185376-2-ynorov@nvidia.com>

On Thu, Jul 02, 2026 at 11:47:14AM -0400, Yury Norov wrote:
> These callbacks are sysfs show paths.
> 
> Use sysfs_emit() and cpumask_pr_args() to emit the masks.
> 
> This prepares for removing cpumap_print_to_pagebuf().
> 
> Signed-off-by: Yury Norov <ynorov@nvidia.com>
> ---
>  arch/arm/mach-imx/mmdc.c     | 2 +-
>  arch/arm/mm/cache-l2x0-pmu.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mmdc.c b/arch/arm/mach-imx/mmdc.c
> index b71467c48b87..f6d993b9b1d4 100644
> --- a/arch/arm/mach-imx/mmdc.c
> +++ b/arch/arm/mach-imx/mmdc.c
> @@ -127,7 +127,7 @@ static ssize_t mmdc_pmu_cpumask_show(struct device *dev,
>  {
>  	struct mmdc_pmu *pmu_mmdc = dev_get_drvdata(dev);
>  
> -	return cpumap_print_to_pagebuf(true, buf, &pmu_mmdc->cpu);
> +	return sysfs_emit(buf, "%*pbl\n", cpumask_pr_args(&pmu_mmdc->cpu));

Really?  Looks like the original is much simpler to understand, why must
this function go away?

thanks,

greg k-h
