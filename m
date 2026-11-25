Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795577108;
	b=v16GOWG7WgiBdovi/VQLIH+2N4nBqTAnDFWo0vQrHP/qP2a/FK6o2xUN3Dd0qINBD29z
	 i1peom51RKLlIZ/9rd6nVLOqLFOlzTNJBKCV32DzHVcT3KRgu71AaX90IA5UNjfdCDpc2
	 ROADgT2oKP02FNDD5/yrCyuOPzEHDfISV0SH3mTQ/Ga7cEYxd6heTXJIOaOQeGCkd40H6
	 cPnE1lHKK69OOgUzDHPW3lDH2kLwCDdPXZmCZeqfCBJbrl98gzG4dgeSdQTDyxooUyAUM
	 8gtgi2hSB8lqwQBk610SXAr6t0ETPPbjV+MIv+LRV93x2V3HbqH+zWfk3X75YHYWX/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795577108;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=jm765WKY/zC72jkI2x569XRAtZ95jMdKBRn4kx2NFXU=;
	b=rrjW1BcU/nROFseWCk6q7Qo7TzWqkB3pNnX9HSi0VYG7k5tDQ44Mqhjh67DnGcGqTwhU
	 yBovC1HEDZ2KwVLJToknA9iPCqzOIFV/NwfB8YHZJPRx+3iGlA6GCgDy98gYEGENx66Md
	 uGMhpCZXZ32fWh6NMAR8SunISKW9k5xhlXGHznp4W9EiNYFXiCaNY5K5YfQY7E7H3rCld
	 UiDAGOD2kfyh6j8MpLg2NacQQtt8dG5ahg8wZpRajOHLnjQCgQnauy9pHvziq9r1RmfMD
	 WgheNPh033Kc+bld/QmlUJTkkEKWYDoJ93OQplN3Xp3znFUVrIxZ+qOySq11D2bmIbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V4AGWGfe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057F4606A31E;
	Wed, 25 Nov 2026 03:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V4AGWGfe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722391F00A3D;
	Wed, 25 Nov 2026 03:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795577107;
	bh=jm765WKY/zC72jkI2x569XRAtZ95jMdKBRn4kx2NFXU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=V4AGWGfeZLmrhtquKRv6EviHYCknQ6uF6sSccjviJ4oFSvgpAICCuQyib02WKudKy
	 WZzoevJXnvM5e8NOpUoL9Ig82rYSxXxmUF9Jr1DLDbm4EjtTfslgzFUp9UHxUlPTv9
	 wrZwz+G0W0uX1L3CBHkaI1MEt38fA9MYeSZuWLQ37eiV+uutE2OGEeTf1isC4/809q
	 ZNbCkMcYIXb3teD/R3X/bXjffIjQmZgy38Wakf++rKKgIEMtzE5TK9nhDC09ZhOLli
	 riBulMJ56RdCaDMuJt8qSHKFWjz1+SQJPB/Yzgx1/6vGL5v3z03GsZeS1enRqA31wI
	 ei8UTG7MewgQw==
Date: Tue, 24 Nov 2026 17:25:06 -1000
Message-ID: <8fefdabc4b1d9e0c0d0b3bae1995e784@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
 Boqun Feng <boqun@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>, Philipp Stanner <phasta@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 =?utf-8?q?Christian_K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>,
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Corey Minyard <corey@minyard.net>, openipmi-developer@lists.sourceforge.net,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev,
 Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Viresh Kumar <viresh.kumar@linaro.org>, linux-arm-msm@vger.kernel.org,
 linux-pm@vger.kernel.org,
 "D. Wythe" <alibuda@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>,
 Sidraya Jayagond <sidraya@linux.ibm.com>,
 Mahanta Jambigi <mjambigi@linux.ibm.com>,
 Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 Oder Chiou <oder_chiou@realtek.com>, Liam Girdwood <lgirdwood@gmail.com>,
 Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
 Takashi Iwai <tiwai@suse.com>, linux-sound@vger.kernel.org,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>,
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, virtualization@lists.linux.dev
Subject: Re: [PATCH 2/2] workqueue: doc: clarify cancel_work_sync() cross-workqueue behavior
In-Reply-To: <20261118-ordered-wq-cancel-v1-2-916e01f9affe@google.com>
References: <20261118-ordered-wq-cancel-v1-0-916e01f9affe@google.com> <20261118-ordered-wq-cancel-v1-2-916e01f9affe@google.com>
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
Content-Transfer-Encoding: 7bit

Applied to wq/for-7.5.

Note that cancel_work_sync() and friends haven't been waiting for a work
item which is still running from a different workqueue since 606a5020b9bd
("workqueue: gut flush[_delayed]_work_sync()") which went in in v3.7. This
has been broken for well over a decade and the documentation now says so.

The following queue the same work item on more than one workqueue and then
sync-cancel or flush it. As cancel_work_sync() doesn't guarantee that the
work item is quiescent in that case, they need to make sure in some other
way, e.g. by flushing the workqueues that are involved. Note that system_wq
and system_percpu_wq, which schedule_work() uses, are different workqueues.
cc'ing the maintainers.

- drivers/char/ipmi/ipmi_msghandler.c: smi_work
- drivers/md/dm-mpath.c: trigger_event
- net/smc/smc_llc.c: llc_event_work
- sound/soc/codecs/rt5651.c: jack_detect_work
- sound/soc/codecs/rt5682s.c: jack_detect_work
- sound/soc/soc-jack.c: snd_soc_jack_gpio.work
- drivers/input/misc/palmas-pwrbutton.c: input_work
- drivers/cpufreq/qcom-cpufreq-hw.c: throttle_work
- drivers/vdpa/vdpa_user/vduse_dev.c: vduse_virtqueue.inject

Thanks.

--
tejun
