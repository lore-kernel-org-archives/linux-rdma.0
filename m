From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 0/5] Support for generalized use of make C={1,2} via
 a wrapper program
Date: Sat, 16 Dec 2017 09:00:01 -0800
Message-ID: <1513443601.4647.36.camel@perches.com>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
         <1513437684.4647.30.camel@perches.com>
         <1513441634.31439.34.camel@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1513441634.31439.34.camel@oracle.com>
Sender: linux-doc-owner@vger.kernel.org
To: Knut Omang <knut.omang@oracle.com>, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, Nicolas Palix <nicolas.palix@imag.fr>, Jonathan Corbet <corbet@lwn.net>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, Matthew Wilcox <willy@infradead.org>, cocci@systeme.lip6.fr, rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org, Doug Ledford <dledford@redhat.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, Shuah Khan <shuah@kernel.org>, linux-kbuild@vger.kernel.org, Michal Marek <michal.lkml@markovi.net>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2017-12-16 at 17:27 +0100, Knut Omang wrote:
> On Sat, 2017-12-16 at 07:21 -0800, Joe Perches wrote:
> > On Sat, 2017-12-16 at 15:42 +0100, Knut Omang wrote:
> > > This patch series implements features to make it easier to run checkers on the
> > > entire kernel as part of automatic and developer testing.
> > 
> > This seems like a useful and reasonable series, thanks.
> 
> thanks, appreciated,
> 
> > Do please take Julia's grammar updates.
> 
> will do,
> 
> > How is this series to be applied?
> 
> I am open for suggestions.
> 
> Let's leave patch #3 out for now.
> 
> It's safe to apply #1 (and #2) alone.

I'd just as soon combine patch #1 and an updated 
patch #2 into a single patch and get that applied
sooner than later.

> They don't break anything by getting into the RDMA or RDS subsystem 
> without patch #1, alternatively they can go together with the set of cleanup patches I
> have prepared for each of RDMA and RDS after #1 is in.

right.
