From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [Qemu-devel] host side todo list for virtio rdma
Date: Sat, 29 Jul 2017 02:48:33 +0300
Message-ID: <20170729024712-mutt-send-email-mst@kernel.org>
References: <20170719004721-mutt-send-email-mst@kernel.org>
 <20170719105549.GB3500@work-vm>
 <20170725165915-mutt-send-email-mst@kernel.org>
 <20170728180255.GF2560@work-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <virtio-dev-return-2427-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
Content-Disposition: inline
In-Reply-To: <20170728180255.GF2560@work-vm>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio@lists.oasis-open.org, virtio-dev@lists.oasis-open.org, linux-rdma@vger.kernel.org, qemu-devel@nongnu.org, Marcel Apfelbaum <marcel.a@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 28, 2017 at 07:02:55PM +0100, Dr. David Alan Gilbert wrote:
> OK, does it seem silly for a message to go all the way to the host
> kernel to then have to go back down to QEMU to be turned back into verbs
> to go back upto the host kernel?

This is how most IO works except vhost.  If it's not a data path
there's no need to write code to avoid some context switches IMHO.

-- 
MST
