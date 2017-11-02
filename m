From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 10/15] IB/core: disable memory registration of
 fileystem-dax vmas
Date: Thu, 2 Nov 2017 14:06:57 -0700
Message-ID: <CAPcyv4g0-kXCXzGo6=3fwaRJTM_4N8BFp+-W71t4Vd_to7LDBA@mail.gmail.com>
References: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150949214929.24061.10464887309708944817.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171102201356.GD5732@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20171102201356.GD5732@lst.de>
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Sean Hefty <sean.hefty@intel.com>, linux-xfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Linux MM <linux-mm@kvack.org>, Doug Ledford <dledford@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 2, 2017 at 1:13 PM, Christoph Hellwig <hch@lst.de> wrote:
> Any chance we could add a new get_user_pages_longerm or similar
> helper instead of opencoding this in the various callers?

Sounds like a great idea to me, I'll take a look...

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
