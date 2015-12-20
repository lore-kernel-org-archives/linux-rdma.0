From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [Cocci] [PATCH] staging/rdma/hfi1: Fix a possible null pointer
 dereference
Date: Sun, 20 Dec 2015 13:59:54 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1512201358040.2067@localhost6.localdomain6>
References: <20151210161338.3341.95259.stgit@phlsvslse11.ph.intel.com>
 <20151214132849.GA22053@osadl.at>
 <alpine.DEB.2.02.1512180727310.2052@localhost6.localdomain6>
 <20151218142025.GA32208@osadl.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20151218142025.GA32208@osadl.at>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, dledford@redhat.com, linux-next@vger.kernel.org, Cocci@systeme.lip6.fr
List-Id: linux-rdma@vger.kernel.org

Here is my proposition for finding missing NULL tests.  I tried to limit 
it to generic kmalloc like functions.  There are of course many other NULL 
returning functions, but maybe they could be in an other rule,

julia

---

/// Look for kmalloc etc that are not followed by a NULL check.
//# May give a false positive when the dereference is an argument of sizeof, or
//# when the value is passed to another function that returns an error code.
///
// Confidence: Moderate
// Copyright: (C) 2015 Julia Lawall, Inria. GPLv2.
// URL: http://coccinelle.lip6.fr/
// Options: --no-includes --include-headers

virtual context
virtual org
virtual report


@ok forall@
expression x;
position p;
statement S1,S2;
@@

(
x =@p \(vmalloc\|kmalloc\|kzalloc\|kcalloc\|kmem_cache_alloc\|krealloc\|
        kmemdup\|kstrdup\|devm_kzalloc\|devm_kmalloc\|devm_kcalloc\|
	devm_kasprintf\|devm_kstrdup\|kmalloc_array\)
	(...,<+... __GFP_NOFAIL ...+>,...);
|
x =@p \(vmalloc\|kmalloc\|kzalloc\|kcalloc\|kmem_cache_alloc\|krealloc\|
        kmemdup\|kstrdup\|devm_kzalloc\|devm_kmalloc\|devm_kcalloc\|
	devm_kasprintf\|devm_kstrdup\|kmalloc_array\)(...)
... when != x
(
 if (x || ...) S1 else S2
|
 (x) == NULL
|
 (x) != NULL
|
 (x) == 0
|
 (x) != 0
)
)

// ----------------------------------------------------------------------------

@err depends on context || org || report exists@
identifier fld;
position p != ok.p;
expression x, y;
position j0, j1, j2;
@@

*  x@j0 =@p \(vmalloc@j1\|kmalloc@j1\|kzalloc@j1\|kcalloc@j1\|
              kmem_cache_alloc@j1\|krealloc@j1\|kmemdup@j1\|kstrdup@j1\|
              devm_kzalloc@j1\|devm_kmalloc@j1\|devm_kcalloc@j1\|
              devm_kasprintf@j1\|devm_kstrdup@j1\|kmalloc_array@j1\)(...);
  ... when != (x) == NULL
      when != (x) != NULL
      when != (x) == 0
      when != (x) != 0
      when != x = y
(
  x@j2->fld
|
  *x@j2
|
  x@j2[...]
)

// ----------------------------------------------------------------------------

@script:python err_org depends on org@
j0 << err.j0;
j1 << err.j1;
j2 << err.j2;
@@

msg = "NULL test needed."
coccilib.org.print_todo(j0[0], msg)
coccilib.org.print_link(j1[0], "")
coccilib.org.print_link(j2[0], "")

// ----------------------------------------------------------------------------

@script:python err_report depends on report@
j0 << err.j0;
j1 << err.j1;
j2 << err.j2;
@@

msg = "NULL test needed, around lines %s,%s." % (j1[0].line,j2[0].line)
coccilib.report.print_report(j0[0], msg)
