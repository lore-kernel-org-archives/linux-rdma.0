From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] IB/srpt: Accept GUIDs as port names
Date: Sat, 28 Jan 2017 09:27:52 +0100
Message-ID: <20170128082752.GD4728@lst.de>
References: <1b20f44a-0378-7b53-65bd-e079e9fa87ff@sandisk.com> <1485293831.43764.89.camel@redhat.com> <1485545556.2432.10.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485545556.2432.10.camel@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, targetcli-fb-devel@lists.fedorahosted.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 27, 2017 at 02:32:36PM -0500, Doug Ledford wrote:
> I've pulled this into my for-next area.  Thanks Bart.

I've taken a look at the code for quite a while on Thursday, but I
have to admit I simply did not understand the magic in it despite
working a lot with configfs and the target code.

Can either of you update target-cli-fb and the documentation to
deal with the new options?
