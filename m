From: Sasha Khapyorsky <sashak@voltaire.com>
Subject: Re: [PATCH] opensm - standardize on a single Windows #define
Date: Tue, 13 Oct 2009 00:00:41 +0200
Message-ID: <20091012220041.GL13830@me>
References: <C014357BC392401989734C286EDC5AE1@amr.corp.intel.com>
	<21B1AC3C6F82416A8764CF0B6FD9C27B@amr.corp.intel.com>
	<3F6F638B8D880340AB536D29CD4C1E1912C8846161@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Disposition: inline
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E1912C8846161@orsmsx501.amr.corp.intel.com>
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

On 10:16 Thu 08 Oct     , Smith, Stan wrote:
> Hefty, Sean wrote:
> >> Code cleanup, standardize on a single Windows #define '__WIN__';
> >> WIN32 --> __WIN__. Flip usage of ifndef WIN32 --> ifdef __GNUC__
> >
> > GNUC indicates a specific compiler, not a platform, which is what the
> > check is for.
> 
> To the best of my understanding OpenSM is built for Linux/OFED, Solaris and Windows.

Also some embedded platforms and we don't know what in a future.

'#ifdef __WIN__' and '#ifndef __GNUC__' are not equivalent.

Sasha
