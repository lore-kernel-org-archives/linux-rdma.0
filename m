From: Adit Ranadive <aditr@vmware.com>
Subject: Re: [PATCH v4 00/16] Add Paravirtual RDMA Driver
Date: Mon, 12 Sep 2016 22:43:00 +0000
Message-ID: <BLUPR0501MB836ED564F2AE7AB9221AC25C5FF0@BLUPR0501MB836.namprd05.prod.outlook.com>
References: <1473655766-31628-1-git-send-email-aditr@vmware.com>
 <20160912180251.GH5843@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20160912180251.GH5843@obsidianresearch.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, pv-drivers <pv-drivers@vmware.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Jorgen S. Hansen" <jhansen@vmware.com>, Aditya Sarwade <asarwade@vmware.com>, George Zhang <georgezhang@vmware.com>, Bryan Tan <bryantan@vmware.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 12, 2016 at 11:03:39 -0700, Jason Gunthorpe wrote:
> On Sun, Sep 11, 2016 at 09:49:10PM -0700, Adit Ranadive wrote:
> > [2] Libpvrdma User-level library -=20
> > http://git.openfabrics.org/?p=3D~aditr/libpvrdma.git;a=3Dsummary
>=20
> You will probably find that rdma-plumbing will be the best way to get
> your userspace component into the distributors.

Hi Jason,

Sorry I haven't paying attention to that discussion. Do you know how soon=20
distros will pick up the rdma-plumbing stuff?=20
It seems like it should be fairly straightforward to include the libpvrdma =
git=20
within the rdma-plumbing git as well. Let me know what the process is since
I may have to discuss it internally.

Thanks!
Adit
