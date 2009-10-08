From: "Sean Hefty" <sean.hefty@intel.com>
Subject: RE: [PATCH] opensm - standardize on a single Windows #define
Date: Thu, 8 Oct 2009 10:22:15 -0700
Message-ID: <452E35E50EEF4860B8A5694626BA3B04@amr.corp.intel.com>
References: <C014357BC392401989734C286EDC5AE1@amr.corp.intel.com>
	<21B1AC3C6F82416A8764CF0B6FD9C27B@amr.corp.intel.com>
	<3F6F638B8D880340AB536D29CD4C1E1912C8846161@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
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
To: "Smith, Stan" <stan.smith@intel.com>, 'Sasha Khapyorsky' <sashak@voltaire.com>
Cc: ofw@lists.openfabrics.org, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

>What would you suggest, given you did not like the ifndef __WIN__ in terms of
>readability?

I was saying that it is slightly easier for me to read:

#ifdef __WIN__
// windows stuff
#else			// <- not __WIN__
// other stuff
#endif

versus

#ifndef __WIN_
// other stuff
#else			// <- not not __WIN__
// windows stuff
#endif

I don't have a problem with the use of __WIN__ or

#ifndef __WIN__
// other stuff
#endif
