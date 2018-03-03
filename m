From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH 2/2] IB/qib: Move char *qib_sdma_state_names[] and
 constify while there.
Date: Sat, 3 Mar 2018 10:31:48 -0500
Message-ID: <ce0ddb85-e008-9895-6508-7d721edeb1de@intel.com>
References: <1519769143-20000-1-git-send-email-hernan@vanguardiasur.com.ar>
 <1519769143-20000-2-git-send-email-hernan@vanguardiasur.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519769143-20000-2-git-send-email-hernan@vanguardiasur.com.ar>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Hern=c3=a1n_Gonzalez?= <hernan@vanguardiasur.com.ar>, mike.marciniszyn@intel.com, dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 2/27/2018 5:05 PM, Hernán Gonzalez wrote:
> Note: This is compile only tested as I have no access to the hw.
> This variable was not used in qib_sdma.c but in qib_iba7322.c. Declaring it
> there, as static, saves 56 bytes.
> 
> add/remove: 0/2 grow/shrink: 0/0 up/down: 0/-144 (-144)
> Function                                     old     new   delta
> qib_sdma_state_names                          56       -     -56
> qib_sdma_event_names                          88       -     -88
> Total: Before=2874565, After=2874421, chg -0.01%
> 
> Signed-off-by: Hernán Gonzalez <hernan@vanguardiasur.com.ar>

Looks OK to me, thanks.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
