From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: [PATCH v2 2/2] x86/mm/pat, drivers/media/ivtv: move pat warn and
 replace WARN() with pr_warn()
Date: Mon, 6 Jul 2015 23:53:20 -0700
Message-ID: <CAB=NE6WzpSLREPkLt0k1_42V5DGKYQx3cqMnGeOFwv1-wkxVhg@mail.gmail.com>
References: <1435166600-11956-1-git-send-email-mcgrof@do-not-panic.com>
 <1435166600-11956-3-git-send-email-mcgrof@do-not-panic.com>
 <20150625065147.GB5339@gmail.com> <20150625173847.GH3005@wotan.suse.de>
 <20150626084546.GD26303@gmail.com> <1435322161.2713.10.camel@localhost>
 <20150629065505.GB17509@gmail.com> <57337D5A-7486-4D01-8316-DFAF4CAF3DA7@md.metrocast.net>
 <20150707004417.GM7021@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150707004417.GM7021@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>, Andy Walls <andy@silverblocksystems.net>, Toshi Kani <toshi.kani@hp.com>, Hyong-Youb Kim <hkim@cspi.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, Borislav Petkov <bp@suse.de>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Doug Ledford <dledford@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>, linux-media@vger.kernel.org, linux-rdma@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 6, 2015 at 5:44 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> If we really wanted to we could consider arch_phys_wc_add()

I mean adding a __arch_phys_wc_add() which does not check for pat_enabled().

> and
> deal with that this will not check for pat_enabled() and forces MTRR...
> I think Andy Luto won't like that very much though ? I at least don't
> like it since we did all this work to finally leave only 1 piece of
> code with direct MTRR access... Seems a bit sad. Since ipath will
> be removed we'd have only ivtv driver using this API, I am not sure if
> its worth it.

Since ipath is going away soon we'd just have one driver with the icky
#ifdef code. I'd rather see that and then require semantics / grammer
rules to require ioremap_wc() when used with arch_phys_wc_add(). I
don't think ivtv is worth to consider breaking the semantics and
requirements.

> Thoughts?

 Luis
