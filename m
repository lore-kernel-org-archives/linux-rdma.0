From: Sasha Khapyorsky <sashak@voltaire.com>
Subject: Re: [PATCH] osmtest - code cleanup
Date: Tue, 13 Oct 2009 00:15:25 +0200
Message-ID: <20091012221525.GN13830@me>
References: <4BFF1A3398A74B2AABB948EF2843BF68@amr.corp.intel.com>
	<20091012214054.GH13830@me>
	<3F6F638B8D880340AB536D29CD4C1E1912C896BB77@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Disposition: inline
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E1912C896BB77@orsmsx501.amr.corp.intel.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "Smith, Stan" <stan.smith@intel.com>
Cc: "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 14:49 Mon 12 Oct     , Smith, Stan wrote:
> 
> How do you feel about replacing ifndef __WIN__ with ifdef __linux__ in other situations?

He-he :) Don't like this:

1. The current porting is going from linux to windows and not otherwise.

2. 'ifndef __WIN__' is not the same as 'ifdef __LIN__' - there are a
non-linux platforms with pretty compatible development tools (such as
Solaris, MacOSX, couple of embedded-es, etc.).

Sasha
